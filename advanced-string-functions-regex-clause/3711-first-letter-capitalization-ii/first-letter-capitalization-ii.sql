WITH RECURSIVE split_words AS (
    SELECT
        content_id,
        content_text,
        1 AS word_num,
        CASE WHEN LOCATE(' ', content_text) = 0 THEN content_text
             ELSE SUBSTRING(content_text, 1, LOCATE(' ', content_text) - 1)
        END AS word,
        CASE WHEN LOCATE(' ', content_text) = 0 THEN ''
             ELSE SUBSTRING(content_text, LOCATE(' ', content_text) + 1)
        END AS remainder
    FROM user_content

    UNION ALL

    SELECT
        content_id,
        content_text,
        word_num + 1,
        CASE WHEN LOCATE(' ', remainder) = 0 THEN remainder
             ELSE SUBSTRING(remainder, 1, LOCATE(' ', remainder) - 1)
        END,
        CASE WHEN LOCATE(' ', remainder) = 0 THEN ''
             ELSE SUBSTRING(remainder, LOCATE(' ', remainder) + 1)
        END
    FROM split_words
    WHERE remainder <> ''
),

transformed AS (
    SELECT
        content_id,
        word_num,
        CASE
            -- exactly one hyphen AND both sides non-empty -> capitalize both parts
            WHEN (LENGTH(word) - LENGTH(REPLACE(word, '-', ''))) = 1
                 AND SUBSTRING_INDEX(word, '-', 1) <> ''
                 AND SUBSTRING(word, LOCATE('-', word) + 1) <> ''
            THEN CONCAT(
                    UPPER(LEFT(SUBSTRING_INDEX(word, '-', 1), 1)),
                    LOWER(SUBSTRING(SUBSTRING_INDEX(word, '-', 1), 2)),
                    '-',
                    UPPER(LEFT(SUBSTRING(word, LOCATE('-', word) + 1), 1)),
                    LOWER(SUBSTRING(SUBSTRING(word, LOCATE('-', word) + 1), 2))
                 )
            -- otherwise treat whole word as a single token
            ELSE CONCAT(
                    UPPER(LEFT(word, 1)),
                    LOWER(SUBSTRING(word, 2))
                 )
        END AS converted_word
    FROM split_words
)

SELECT
    uc.content_id,
    uc.content_text AS original_text,
    GROUP_CONCAT(t.converted_word ORDER BY t.word_num SEPARATOR ' ') AS converted_text
FROM user_content uc
JOIN transformed t ON uc.content_id = t.content_id
GROUP BY uc.content_id, uc.content_text
ORDER BY uc.content_id;