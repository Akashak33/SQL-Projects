/*Q.1)  Senior most employee based on Job title*/
select * from
music_store.employee
order by levels desc
limit 1;

/*Q.2) Which countries has the most invoices*/
select billing_country, count(invoice_id) as invoice_count
from music_store.invoice
group by billing_country
order by count(invoice_id) desc
limit 1;

/*Q.3) What are top 3 values of total invoices*/
select round(total,2)
from music_store.invoice
group by total
order by total desc
limit 3;

/*Q.4) Which city has the best customers? We would like to throw a promotional music festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. Return both the city name & sum of all invoice totals*/
select billing_city, round(sum(total),2) as totals
from music_store.invoice
group by billing_city 
order by sum(total) desc
limit 1;

/*Q.4) Who is the best customer? The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/
with best_customer as(
select customer_id, sum(total) as totals
from music_store.invoice inv
group by customer_id
order by totals desc
limit 1)
select bc.customer_id,cus.first_name, cus.last_name
from music_store.customer cus
inner join best_customer bc on bc.customer_id=cus.customer_id;

/*Q.5) Write a query to return the email, first name, last name, & genre of all Rock Music listeners. 
Return your list ordered alphabetically be email starting with A.*/
select distinct cus.email, cus.first_name, cus.last_name, genre.name
from music_store.customer cus
inner join music_store.invoice inv on cus.customer_id = inv.customer_id
inner join music_store.invoice_line invl on inv.invoice_id = invl.invoice_id
inner join music_store.track on invl.track_id = track.track_id
inner join music_store.genre on track.genre_id = genre.genre_id
where genre.name = 'Rock'
order by email;

/*Q.6) Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the artist name and total track count of the top 10 rock bands*/
select artist.name, genre.name, count(artist.artist_id) as no_of_songs
from music_store.artist
inner join music_store.album on artist.artist_id = album.artist_id
inner join music_store.track on album.album_id = track.album_id
inner join music_store.genre on track.genre_id = genre.genre_id
where genre.name = 'rock'
group by artist.name
order by count(artist.artist_id) asc
limit 10;

/*Q.7) Return all the track names that have a song length longer than the average song length. 
Return the name and milliseconds for each track. Order by the song lemgth with the longest songs listed first.*/
select name, milliseconds
from music_store.track
where milliseconds > (select avg(milliseconds)
						from music_store.track)
order by milliseconds desc;

/*Q.8) Find how much amount spent by each customer on artist? Write a query to return customer name, artist name and total spent.*/
select inv.customer_id, inv.total, artist.name
from music_store.invoice inv
inner join music_store.invoice_line invl on inv.invoice_id = invl.invoice_id
inner join music_store.track on invl.track_id = track.track_id
inner join music_store.album on track.album_id = album.album_id
inner join music_store.artist on album.artist_id = artist.artist_id;

/*Q.9) We want to find out the most popular music genre for each country. We determine the most popular genre as the genre with 
the highest quantity of purchase. write a query that returns each country along with the top genre. For countries where the maximum 
number of purchases is shared return all genres.*/
With Recursive sales_per_country as(
select count(*) as Purchase_per_Genre, customer.country, genre.name, genre.genre_id
from music_store.invoice_line
inner join music_store.invoice on invoice.invoice_id = invoice_line.invoice_id
inner join music_store.customer on customer.customer_id = invoice.customer_id
inner join music_store.track on track.track_id = invoice_line.track_id
inner join music_store.genre on genre.genre_id = track.genre_id
group by 2,3,4
order by 2),
max_genre_per_country as (
select max(purchase_per_genre) as max_genre_number, country
from sales_per_country
group by 2
order by 2)
select sales_per_country.*
from sales_per_country
inner join max_genre_per_country on sales_per_country.country = max_genre_per_country.country
where sales_per_country.purchase_per_genre = max_genre_per_country.max_genre_number;

/*Q/10) Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with top customer and how much they spent. For countries where 
the top amount spent is shared, provide all customers who spent this amount.*/
with recursive customer_with_country as(
select customer.customer_id, first_name, last_name, billing_country, sum(total) as total_spending
from music_store.invoice
inner join music_store.customer on customer.customer_id = invoice.customer_id
group by 1,2,3,4
order by 1,5 desc),
country_max_spending as(
select billing_country, max(total_spending) as max_spending
from customer_with_country
group by billing_country)
select cc.billing_country, cc.total_spending, cc.first_name, cc.last_name, cc.customer_id
from customer_with_country cc
inner join country_max_spending ms on cc.billing_country = ms.billing_country
where cc.total_spending = ms.max_spending
order by 1;


