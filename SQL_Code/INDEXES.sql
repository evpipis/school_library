/* Indexes */
create index book_title_id_idx on book_categories(book_id);
create index book_title_id_idx on book_authors(book_id);
create index school_unit_id_idx on user(school_id);
create index user_id_idx on review(user_id);
create index book_title_idx on review(book_id);
create index book_title_id_idx on book_keywords(book_id);
create index number_of_copies_idx on book_instance(copies);
create index borrowing_date_idx on borrowing(borrow_date);
create index date_of_birth_idx on user(birth_date);