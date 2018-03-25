REST API

GET /calendar
→直近1か月のカレンダー情報を返す
  { { 'year:2018' , 'month:1' ,'day:1' , 'reserved:yes' } , { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }, { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }}

GET /calendar/1
→直近1か月のカレンダー情報を返す
  { { 'year:2018' , 'month:1' ,'day:1' , 'reserved:yes' } , { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }, { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }}

GET /calendar/2
→直近2か月のカレンダー情報を返す
  { { 'year:2018' , 'month:1' ,'day:1' , 'reserved:yes' } , { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }, { 'year:2018' , 'month:1' ,'day:2' , 'reserved:yes' }}

POST /calendar
  + { 'reserve:yes', 'email:mail@example.com' , { 'year:2018' , 'month:1' ,'day:1' } , { 'year:2018' , 'month:1' ,'day:2' }, { 'year:2018' , 'month:1' ,'day:2' }}
→カレンダーに予約情報を登録


