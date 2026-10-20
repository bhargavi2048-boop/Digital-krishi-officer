package com.krishiofficer.config;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

import javax.sql.DataSource;
import java.net.URI;
import java.sql.Connection;

/**
 * Resilient Database Configuration for Digital Krishi Officer.
 * Automatically adapts Render PostgreSQL (postgres:// or postgresql://) connection strings,
 * standard JDBC PostgreSQL URLs, or falls back safely to in-memory H2 database.
 */
@Configuration
public class DatabaseConfig {

    private static final Logger log = LoggerFactory.getLogger(DatabaseConfig.class);

    @Value("${spring.datasource.username:sa}")
    private String defaultUsername;

    @Value("${spring.datasource.password:password}")
    private String defaultPassword;

    @Bean
    @Primary
    public DataSource dataSource() {
        String rawUrl = resolveDatabaseUrl();
        log.info("🔍 Resolving database connection. Configured URL: {}", maskUrl(rawUrl));

        if (rawUrl != null && (rawUrl.startsWith("postgres://") || rawUrl.startsWith("postgresql://"))) {
            try {
                return createPostgresDataSourceFromUri(rawUrl);
            } catch (Exception e) {
                log.error("⚠️ Failed to parse/connect to PostgreSQL URI: {}. Falling back to H2.", e.getMessage());
                return createH2FallbackDataSource();
            }
        } else if (rawUrl != null && rawUrl.startsWith("jdbc:postgresql://")) {
            try {
                return createPostgresDataSourceFromJdbc(rawUrl);
            } catch (Exception e) {
                log.error("⚠️ Failed to connect to PostgreSQL JDBC: {}. Falling back to H2.", e.getMessage());
                return createH2FallbackDataSource();
            }
        } else {
            log.info("📦 Using local in-memory H2 database.");
            return createH2FallbackDataSource();
        }
    }

    private String resolveDatabaseUrl() {
        String envUrl = System.getenv("SPRING_DATASOURCE_URL");
        if (envUrl != null && !envUrl.isBlank()) return envUrl.trim();

        envUrl = System.getenv("DATABASE_URL");
        if (envUrl != null && !envUrl.isBlank()) return envUrl.trim();

        String propUrl = System.getProperty("spring.datasource.url");
        if (propUrl != null && !propUrl.isBlank()) return propUrl.trim();

        return null;
    }

    private DataSource createPostgresDataSourceFromUri(String rawUri) {
        try {
            // Replace postgresql:// with http:// temporarily for clean URI parsing if needed
            String cleanUri = rawUri;
            if (cleanUri.startsWith("postgres://")) {
                cleanUri = "http://" + cleanUri.substring("postgres://".length());
            } else if (cleanUri.startsWith("postgresql://")) {
                cleanUri = "http://" + cleanUri.substring("postgresql://".length());
            }

            URI uri = new URI(cleanUri);
            String username = defaultUsername;
            String password = defaultPassword;

            if (uri.getUserInfo() != null && !uri.getUserInfo().isBlank()) {
                String[] parts = uri.getUserInfo().split(":", 2);
                username = parts[0];
                if (parts.length > 1) {
                    password = parts[1];
                }
            }

            String host = uri.getHost();
            int port = uri.getPort() > 0 ? uri.getPort() : 5432;
            String dbName = uri.getPath() != null && !uri.getPath().isEmpty() ? uri.getPath() : "/krishidb";

            String jdbcUrl = "jdbc:postgresql://" + host + ":" + port + dbName;
            if (uri.getQuery() != null && !uri.getQuery().isBlank()) {
                jdbcUrl += "?" + uri.getQuery();
            } else {
                jdbcUrl += "?sslmode=require";
            }

            log.info("🔌 Converted Render URL to JDBC: {} (User: {})", maskUrl(jdbcUrl), username);

            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(jdbcUrl);
            config.setDriverClassName("org.postgresql.Driver");
            config.setUsername(username);
            config.setPassword(password);
            config.setMaximumPoolSize(4);
            config.setMinimumIdle(1);
            config.setConnectionTimeout(15000);
            config.setIdleTimeout(300000);
            config.setMaxLifetime(600000);

            HikariDataSource ds = new HikariDataSource(config);

            // Test connection with 5s timeout
            try (Connection conn = ds.getConnection()) {
                log.info("✅ Successfully verified connection to PostgreSQL database!");
                return ds;
            } catch (Exception ex) {
                log.error("❌ PostgreSQL connection test failed: {}", ex.getMessage());
                ds.close();
                return createH2FallbackDataSource();
            }
        } catch (Exception e) {
            log.error("❌ Error parsing PostgreSQL URI: {}", e.getMessage(), e);
            return createH2FallbackDataSource();
        }
    }

    private DataSource createPostgresDataSourceFromJdbc(String jdbcUrl) {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(jdbcUrl);
        config.setDriverClassName("org.postgresql.Driver");
        config.setUsername(defaultUsername);
        config.setPassword(defaultPassword);
        config.setMaximumPoolSize(4);
        config.setMinimumIdle(1);
        config.setConnectionTimeout(15000);

        HikariDataSource ds = new HikariDataSource(config);
        try (Connection conn = ds.getConnection()) {
            log.info("✅ Successfully verified connection to PostgreSQL JDBC database!");
            return ds;
        } catch (Exception ex) {
            log.error("❌ PostgreSQL JDBC connection test failed: {}", ex.getMessage());
            ds.close();
            return createH2FallbackDataSource();
        }
    }

    private DataSource createH2FallbackDataSource() {
        log.info("🛡️ Initializing H2 in-memory resilient database (h2:mem:krishidb)");
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:h2:mem:krishidb;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE;MODE=PostgreSQL");
        config.setDriverClassName("org.h2.Driver");
        config.setUsername("sa");
        config.setPassword("password");
        config.setMaximumPoolSize(5);
        return new HikariDataSource(config);
    }

    private String maskUrl(String url) {
        if (url == null) return "null";
        return url.replaceAll(":[^:@/]+@", ":****@");
    }
}
