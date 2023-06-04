/* TRIGGERS */
DELIMITER //
DROP TRIGGER IF EXISTS activateReservationOnUpdate//
-- this activates pending reservation when the requested book_instance becomes available
-- there are no reservation before inserting the book_instance on the library
CREATE TRIGGER activateReservationOnUpdate BEFORE UPDATE ON book_instance FOR EACH ROW
BEGIN
	-- add copies one by one in the database
	WHILE NEW.copies > 0
		AND NOT EXISTS (SELECT 1 FROM Disabled_Triggers where TriggerName = 'activateReservationOnUpdate')
		AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		-- make reservation 'active' from 'pending'
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        -- bind one copy of the book_instance for the reservation just activated
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END //	
DELIMITER ;

DELIMITER //
DROP TRIGGER IF EXISTS activateReservationOnInsert//
-- this activates pending reservation when the requested book_instance becomes available
-- there are no reservation before inserting the book_instance on the library
CREATE TRIGGER activateReservationOnInsert BEFORE INSERT ON book_instance FOR EACH ROW
BEGIN
	-- add copies one by one in the database
	WHILE NEW.copies > 0 AND EXISTS (
		SELECT * FROM reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
	) DO
		-- make reservation 'active' from 'pending'
        UPDATE reservation
        INNER JOIN user
        ON reservation.user_id = user.id
        SET reservation.status = 'active', reservation.reserve_date = CURRENT_DATE()
        WHERE user.school_id = NEW.school_id AND reservation.book_id = NEW.book_id AND reservation.status = 'pending'
        ORDER BY reservation.id
        LIMIT 1;
        
        -- bind one copy of the book_instance for the reservation just activated
        SET NEW.copies = NEW.copies-1;
    END WHILE;
END //	
DELIMITER ;





