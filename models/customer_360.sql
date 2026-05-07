WITH customers AS (

    SELECT
        customerid,
        fullname,
        customersince,
        customersegment
    FROM ACME_BANK.ACME_MORTGAGE.customers

),

credit_profiles AS (

    SELECT
        customerid,
        creditscore,
        creditrating,
        annualincome,
        debttoincomeratio,
        maxborrowingcapacity
    FROM ACME_BANK.ACME_MORTGAGE.creditprofiles

),

loan_applications AS (

    SELECT
        customerid,
        requestedamount,
        applicationstatus,
        loantype,
        lvr
    FROM ACME_BANK.ACME_MORTGAGE.loanapplications

),

product_holdings AS (

    SELECT
        customerid,
        COUNT(productid) AS total_products,
        SUM(balance) AS total_balance
    FROM ACME_BANK.ACME_MORTGAGE.productholdings
    GROUP BY customerid

)

SELECT
    c.customerid,
    c.fullname,
    c.customersegment,
    c.customersince,

    cp.creditscore,
    cp.creditrating,
    cp.annualincome,
    cp.debttoincomeratio,
    cp.maxborrowingcapacity,

    la.requestedamount,
    la.applicationstatus,
    la.loantype,
    la.lvr,

    ph.total_products,
    ph.total_balance,

    CASE
        WHEN la.requestedamount <= cp.maxborrowingcapacity
        THEN 'Within Capacity'
        ELSE 'Exceeds Capacity'
    END AS borrowing_capacity_check

FROM customers c

LEFT JOIN credit_profiles cp
    ON c.customerid = cp.customerid

LEFT JOIN loan_applications la
    ON c.customerid = la.customerid

LEFT JOIN product_holdings ph
    ON c.customerid = ph.customerid
