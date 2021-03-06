USE lead_gen_business;

-- billing, clients, leads, sites --

SELECT * FROM billing;
SELECT * FROM clients;
SELECT * FROM leads;
SELECT * FROM sites;

-- 1. What query would you run to get the total revenue for March of 2012?
SELECT MONTHNAME(charged_datetime) AS month, SUM(amount) as total_revenue 
FROM billing
WHERE charged_datetime LIKE "2012-03%";


-- 2. What query would you run to get total revenue collected from the client with an id of 2?
SELECT client_id, SUM(amount) as total_revenue
FROM billing
WHERE client_id = 2;


-- 3. What query would you run to get all the sites that client=10 owns?
SELECT domain_name, client_id 
FROM sites
WHERE client_id = 10;


-- 4. What query would you run to get total # of sites created each month for the client with an id of 1? 
-- What about for client=20?

-- for client_id = 1 --
SELECT client_id, COUNT(domain_name) AS num_sites, MONTHNAME(created_datetime) AS month, YEAR(created_datetime) AS year
FROM sites
WHERE client_id = 1
GROUP BY MONTHNAME(created_datetime), YEAR(created_datetime)
ORDER BY year ASC;

-- for client_id = 20 --
SELECT client_id, COUNT(domain_name) AS num_sites, MONTHNAME(created_datetime) AS month, YEAR(created_datetime) AS year
FROM sites
WHERE client_id = 20
GROUP BY MONTHNAME(created_datetime), YEAR(created_datetime)
ORDER BY year ASC;

-- 5. What query would you run to get the total # of leads we've generated for each of our sites 
-- between January 1, 2011 to February 15, 2011?
SELECT COUNT(leads.leads_id) AS total_leads, DATE_FORMAT(leads.registered_datetime, '%M %e, %Y') AS date, sites.domain_name
FROM leads
LEFT JOIN sites ON leads.site_id = sites.site_id
WHERE YEAR(registered_datetime) = 2011 AND (MONTHNAME(registered_datetime) = "January" OR MONTHNAME(registered_datetime) = "February")
GROUP BY sites.site_id
ORDER BY date DESC;

-- 6. What query would you run to get a list of client names and the total # of leads 
-- we've generated for each of our clients between January 1, 2011 to December 31, 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, COUNT(leads.leads_id) AS num_leads
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE YEAR(leads.registered_datetime) = 2011
GROUP BY name
ORDER BY num_leads DESC;


-- 7. What query would you run to get a list of client name and the total # of leads 
-- we've generated for each client each month between month 1 - 6 of Year 2011?
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, COUNT(leads.leads_id) AS num_leads, MONTHNAME(leads.registered_datetime) as month
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE YEAR(leads.registered_datetime) = 2011 AND (MONTH(leads.registered_datetime) BETWEEN 1 and 6)
GROUP BY name, month 
ORDER BY MONTH(leads.registered_datetime);

-- 8. What query would you run to get a list of client name and the total # of leads 
-- we've generated for each of our client's sites between January 1, 2011 to December 31, 2011? 
-- Come up with a second query that shows all the clients, the site name(s), and the total number of 
-- leads generated from each site for all time.
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, COUNT(leads.leads_id) AS num_leads, sites.domain_name AS domain_name, DATE_FORMAT(leads.registered_datetime, '%M %e, %Y') AS date_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
WHERE YEAR(leads.registered_datetime) = 2011
GROUP BY domain_name
ORDER BY clients.last_name;

-- Second part --
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, COUNT(leads.leads_id) AS num_leads, sites.domain_name AS domain_name, DATE_FORMAT(leads.registered_datetime, '%M %e, %Y') AS date_generated
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
LEFT JOIN leads ON sites.site_id = leads.site_id
GROUP BY domain_name
ORDER BY clients.last_name;

-- 9. Write a single query that retrieves total revenue collected from each client each month of the year.
SELECT * FROM billing;
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, SUM(billing.amount) AS total_revenue, MONTHNAME(billing.charged_datetime) AS month, YEAR(billing.charged_datetime) as year
FROM clients
LEFT JOIN billing ON clients.client_id = billing.client_id
GROUP BY name, month, year
ORDER BY clients.last_name, billing.charged_datetime;

-- 10. Write a single query that retrieves all the sites that each client owns. 
-- Group the results so that each row shows a new client. 
-- Add a new field called 'sites' that has all the sites that the client owns. (HINT: use GROUP_CONCAT)
SELECT CONCAT(clients.first_name, ' ', clients.last_name) as name, GROUP_CONCAT(' ', sites.domain_name) AS sites
FROM clients
LEFT JOIN sites ON clients.client_id = sites.client_id
GROUP BY name;
