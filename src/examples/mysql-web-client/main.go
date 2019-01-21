package main

import (
	"context"
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"database/sql"

	_ "github.com/go-sql-driver/mysql"

	"github.com/ryanmoran/viron"
)

type Handler struct {
	MySQLDSN string
}

type ConnInfo struct {
	ClientHost string
	TLSCipher  string
}

func (h *Handler) probeMySQL(ctx context.Context) (*ConnInfo, error) {
	// open a new conn each time, because we don't want connection pooling
	dbConnPool, err := sql.Open("mysql", h.MySQLDSN)
	if err != nil {
		return nil, fmt.Errorf("sql.Open: %s", err)
	}
	defer dbConnPool.Close() // we do this because we want a new conn each time!

	if err = dbConnPool.PingContext(ctx); err != nil {
		return nil, fmt.Errorf("ping: %s", err)
	}

	connInfo := &ConnInfo{}

	const connQuery = "SELECT host FROM information_schema.processlist WHERE ID=connection_id();"
	if err = dbConnPool.QueryRowContext(ctx, connQuery).Scan(&connInfo.ClientHost); err != nil {
		return nil, fmt.Errorf("detecting client: %s", err)
	}

	const cipherQuery = "SHOW STATUS LIKE 'SSL_cipher'"
	var itemName string
	if err = dbConnPool.QueryRowContext(ctx, cipherQuery).Scan(&itemName, &connInfo.TLSCipher); err != nil {
		return nil, fmt.Errorf("detecting cipher: %s", err)
	}

	return connInfo, nil
}

func (h *Handler) ServeHTTP(resp http.ResponseWriter, req *http.Request) {
	connInfo, err := h.probeMySQL(req.Context())
	if err != nil {
		log.Printf("error probing database: %s", err)
		resp.WriteHeader(http.StatusInternalServerError)
		fmt.Fprintf(resp, "error probing database, see logs for details")
		return
	}

	resp.WriteHeader(http.StatusOK)
	json.NewEncoder(resp).Encode(connInfo)
}

type Config struct {
	ListenPort    string `env:"PORT" env-required:"true"`
	MySQLHost     string `env:"MYSQL_HOST" env-required:"true"`
	MySQLPort     string `env:"MYSQL_PORT" env-default:"3306"`
	MySQLUser     string `env:"MYSQL_USER" env-required:"true"`
	MySQLPassword string `env:"MYSQL_PASSWORD"`
}

func (c *Config) DSN() string {
	return fmt.Sprintf("%s:%s@tcp(%s:%s)/", c.MySQLUser, c.MySQLPassword, c.MySQLHost, c.MySQLPort)
}

func main() {
	cfg := &Config{}
	if err := viron.Parse(cfg); err != nil {
		log.Fatalf("parsing env vars: %s", err)
	}

	handler := &Handler{MySQLDSN: cfg.DSN()}
	http.ListenAndServe(fmt.Sprintf("0.0.0.0:%s", cfg.ListenPort), handler)
}
