SELECT
    ip,
    COUNT(*) AS invalid_count
FROM logs
WHERE
    -- not exactly 4 octets
    LENGTH(ip) - LENGTH(REPLACE(ip, '.', '')) <> 3

    -- any octet > 255
    OR ip REGEXP '(^|\\.)(25[6-9]|2[6-9][0-9]|[3-9][0-9]{2,})(\\.|$)'

    -- leading zeros
    OR ip REGEXP '(^|\\.)0[0-9]+(\\.|$)'
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;