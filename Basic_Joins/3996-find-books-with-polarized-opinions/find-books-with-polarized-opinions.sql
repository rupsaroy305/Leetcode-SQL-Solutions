SELECT b.book_id,b.title,b.author,b.genre,b.pages,MAX(session_rating)-MIN(session_rating) AS rating_spread,ROUND(SUM(session_rating<=2 OR session_rating>=4)/COUNT(*),2) AS polarization_score
FROM books b
JOIN reading_sessions r ON b.book_id=r.book_id
GROUP BY b.book_id,b.title,b.author,b.genre,b.pages
HAVING COUNT(*)>=5
AND MAX(session_rating)>=4
AND MIN(session_rating)<=2
AND SUM(session_rating<=2 OR session_rating>=4)/COUNT(*)>=0.6
ORDER BY polarization_score DESC,title DESC;