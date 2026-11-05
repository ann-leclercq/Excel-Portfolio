-- 1. Explore: look at every column in the Tickets table
--    (329 rows)

SELECT * FROM Tickets;

-- 2. Explore: look at every column in the Clients table
--    (10 rows)

SELECT * FROM Clients;

-- 3. Join: put each ticket together with its client's name, industry and tier
--    The ticket system only knows Client_ID. Name and tier live in Clients.
--    (329 rows)

SELECT * FROM Tickets
JOIN Clients
ON Tickets.Client_ID = Clients.Client_ID;

-- 4. Work queue: tickets that are still Open AND past their SLA,
--    oldest first, so the team knows what to chase today
--    (17 rows)

SELECT * FROM Tickets
JOIN Clients
ON Tickets.Client_ID = Clients.Client_ID
WHERE Status = 'Open'
AND Past_SLA = 'Yes'
ORDER BY Date_Opened ASC;

-- 5. Volume: every Password / Access ticket
--    This is the biggest category. Is it also the most work?
--    (95 rows)

SELECT * FROM Tickets
WHERE Category = 'Password / Access'
ORDER BY Tech_Hours DESC;


-- 6. Trend: Network tickets opened in October, with client names,
--    sorted by client name so tickets from the same client sit together
--    (33 rows)

SELECT * FROM Tickets
JOIN Clients
ON Tickets.Client_ID = Clients.Client_ID
WHERE Category = 'Network'
AND Date_Opened >= '2026-10-01'
ORDER BY Client_Name ASC;

-- 7. Root cause: past-SLA tickets held up by an outside supplier,
--    meaning the delay reason is Waiting on vendor OR Parts on order.
--    (28 rows)

SELECT * FROM Tickets
JOIN Clients
ON Tickets.Client_ID = Clients.Client_ID
WHERE Past_SLA = 'Yes'
AND (Delay_Reason = 'Waiting on vendor' OR Delay_Reason = 'Parts on order');


-- 8. Tier check: past-SLA tickets for Gold clients, with client names,
--    oldest first
--    (38 rows)

SELECT * FROM Tickets
JOIN Clients
ON Tickets.Client_ID = Clients.Client_ID
WHERE Past_SLA = 'Yes'
AND Service_Tier = 'Gold'
ORDER BY Date_Opened ASC;