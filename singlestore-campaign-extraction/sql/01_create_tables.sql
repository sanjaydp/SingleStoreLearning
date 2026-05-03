USE db_sanjay_543dd;

DROP TABLE IF EXISTS campaign_history;
DROP TABLE IF EXISTS suppression_list;
DROP TABLE IF EXISTS credit_attributes;
DROP TABLE IF EXISTS consumer_profile;

CREATE TABLE consumer_profile (
    consumer_id BIGINT NOT NULL,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    address_line VARCHAR(200),
    city VARCHAR(100),
    state CHAR(2),
    zip_code VARCHAR(10),
    income_band VARCHAR(20),
    PRIMARY KEY (consumer_id),
    SHARD KEY (consumer_id)
);

CREATE TABLE credit_attributes (
    consumer_id BIGINT NOT NULL,
    credit_score INT,
    ml_response_score DOUBLE,
    total_debt DECIMAL(12,2),
    revolving_debt DECIMAL(12,2),
    mortgage_balance DECIMAL(12,2),
    auto_loan_balance DECIMAL(12,2),
    updated_at DATE,
    PRIMARY KEY (consumer_id),
    SHARD KEY (consumer_id)
);

CREATE TABLE suppression_list (
    suppression_id BIGINT NOT NULL,
    client_id VARCHAR(30),
    consumer_id BIGINT NOT NULL,
    suppression_reason VARCHAR(100),
    created_at DATE,
    PRIMARY KEY (consumer_id, suppression_id),
    SHARD KEY (consumer_id)
);

CREATE TABLE campaign_history (
    campaign_id BIGINT NOT NULL,
    client_id VARCHAR(30),
    consumer_id BIGINT NOT NULL,
    campaign_date DATE,
    response_flag TINYINT,
    conversion_flag TINYINT,
    PRIMARY KEY (consumer_id, campaign_id),
    SHARD KEY (consumer_id)
);
