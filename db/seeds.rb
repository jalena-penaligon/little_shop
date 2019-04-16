OrderItem.destroy_all
Order.destroy_all
Item.destroy_all
User.destroy_all

u_01 = User.create(name: "Michael Foreman", address: "1066 Birch Street" , city: "Indianapolis", state: "IN", zip: "46278", email: "mforeman@produce.com", password: "orange123")
u_02 = User.create(name: "Jose Kent", address: "1668 Crestview Terrace" , city: "Pleasanton", state: "TX", zip: "74135", email: "jkent@produce.com", password: "apple123")
u_03 = User.create(name: "Barbara Clayton", address: "3419 Heliport Loop" , city: "Leavenworth", state: "IN", zip: "47137", email: "bkent@produce.com", password: "avocado123")
u_04 = User.create(name: "Anya Nambisan", address: "4163 Bottom Lane" , city: "Buffalo", state: "NY", zip: "14202", email: "anambisan@produce.com", password: "kale123")
u_05 = User.create(name: "Luiza Grabowska", address: "1000 School Street" , city: "Danbury", state: "CT", zip: "06810", email: "lgrabowska@produce.com", password: "banana123")
u_06 = User.create(name: "Russell Zwager", address: "3019 Cambridge Drive" , city: "Peoria", state: "AZ", zip: "85382", email: "rzwagar@produce.com", password: "pineapple123")
u_07 = User.create(name: "Sheng Fan", address: "1356 Providence Lane" , city: "Pleasanton", state: "TX", zip: "74135", email: "sfan@produce.com", password: "pineapple123")
u_08 = User.create(name: "Viollette Pouliotte", address: "3673 Jennifer Lane" , city: "Buffalo", state: "NY", zip: "14202", email: "vpouliotte@produce.com", password: "tomato123")
u_09 = User.create(name: "Swen Keller", address: "2635 Hillview Drive" , city: "Buffalo", state: "NY", zip: "14202", email: "skeller@produce.com", password: "spinach123")
u_10 = User.create(name: "Scarlett Spencer", address: "1333 Layman Court" , city: "Denver", state: "CO", zip: "80207", email: "sspencer@produce.com", password: "peach123")

admin = User.create(name: "Admin", address: "1331 17th Street" , city: "Denver", state: "CO", zip: "80202", email: "admin@chezproduce.com", password: "admin", role: 2)

m_01 = User.create(name: "Sam's Produce", address: "5105 Cook St" , city: "Denver", state: "CO", zip: "80216", email: "sams@samsproduce.com", password: "fruity", role: 1, created_at: 37.days.ago)
m_02 = User.create(name: "JM Farms", address: "415 Yuma St" , city: "Denver", state: "CO", zip: "80204", email: "yuma@yumafarms.com", password: "vegetables", role: 1, created_at: 34.days.ago)
m_03 = User.create(name: "Fresh Start Produce", address: "3225 Denargo St" , city: "Denver", state: "CO", zip: "80216", email: "freshstart@freshstartproducetoo.com", password: "bountiful", role: 1, created_at: 31.days.ago)
m_04 = User.create(name: "Fresh Guys Produce", address: "1890 E 58th Ave" , city: "Denver", state: "CO", zip: "80216", email: "freshguys@freshguysproduce.com", password: "fresh", role: 1, created_at: 28.days.ago)
m_05 = User.create(name: "Tucci Fresh Produce", address: "850 E 50th Ave A" , city: "Denver", state: "CO", zip: "80216", email: "tucci@tuccifreshproduce.com", password: "tucci", role: 1, created_at: 25.days.ago)
m_06 = User.create(name: "American Produce", address: "5151 Bannock St # 3" , city: "Denver", state: "CO", zip: "80216", email: "american@americanproduce.com", password: "fruity", role: 1, created_at: 22.days.ago)
m_07 = User.create(name: "Growers Organic", address: "6400 Broadway # 11" , city: "Denver", state: "CO", zip: "80221", email: "growers@growersorganic.com", password: "veggie", role: 1, created_at: 19.days.ago)
m_08 = User.create(name: "Paradigm Fresh", address: "4823 Lima St B" , city: "Denver", state: "CO", zip: "80239", email: "paradigm@paradigmfresh.com", password: "veggie", role: 1, created_at: 16.days.ago)

it_01 = m_01.items.create(name: "Apple", image: "https://images.unsplash.com/photo-1478004521390-655bd10c9f43?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80", description: "Gala Apple, One Medium..", inventory: 15, price: 0.50, active: true)
it_02 = m_01.items.create(name: "Avocado", image: "https://images.unsplash.com/photo-1512070904629-fa988dab2fe1?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80", description: "Hass Avocado, One Large.", inventory: 7, price: 1.42, active: true)
it_03 = m_02.items.create(name: "Bananas", image: "https://images.unsplash.com/reserve/RNm0KceQ4Gbpb0xldOe7_DSC_0679_2.JPG?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1602&q=80", description: "One bunch, 5-7 bananas.", inventory: 21, price: 1.79, active: true)
it_04 = m_02.items.create(name: "Blackberries", image: "https://images.unsplash.com/photo-1474480109237-15a7ca8f0685?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1653&q=80", description: "Blackberries, 6 oz.", inventory: 14, price: 2.99, active: true)
it_05 = m_03.items.create(name: "Blueberries", image: "https://images.unsplash.com/photo-1498557850523-fd3d118b962e?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80", description: "Organic Blueberries, 6 oz. ", inventory: 12, price: 3.99, active: true)
it_06 = m_03.items.create(name: "Brussel Sprouts", image: "https://images.unsplash.com/photo-1438118907704-7718ee9a191a?ixlib=rb-1.2.1&auto=format&fit=crop&w=1650&q=80", description: "Brussels Sprouts, 12 oz Bag.", inventory: 21, price: 2.99, active: true)
it_07 = m_03.items.create(name: "Carrots", image: "https://images.unsplash.com/photo-1445282768818-728615cc910a?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80", description: "Organic Carrots, 1 lb.", inventory: 28, price: 0.99, active: true)
it_08 = m_04.items.create(name: "Garlic", image: "https://images.unsplash.com/photo-1441861539200-6208cf4a122f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1100&q=80", description: "Organic Garlic, One Medium.", inventory: 42, price: 1.99, active: true)
it_09 = m_04.items.create(name: "Kale", image: "https://images.unsplash.com/photo-1524179091875-bf99a9a6af57?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80", description: "Organic Kale, One Bunch.", inventory: 17, price: 2.99, active: true)
it_10 = m_05.items.create(name: "Orange", image: "https://images.unsplash.com/photo-1482012792084-a0c3725f289f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80", description: "Navel Orange, One Medium.", inventory: 22, price: 0.79, active: true)
it_11 = m_05.items.create(name: "Pineapple", image: "https://images.unsplash.com/photo-1439478580632-ca2f5e3767af?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80", description: "Gold Pineapple, One Medium.", inventory: 11, price: 2.50, active: true)
it_12 = m_06.items.create(name: "Pomegranate", image: "https://images.unsplash.com/photo-1507654304600-18d902b183b4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=939&q=80", description: "Pomegranate, One Medium.", inventory: 4, price: 2.99, active: true)
it_13 = m_07.items.create(name: "Spinach", image: "https://images.unsplash.com/photo-1515363578674-99f41329ab4c?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1647&q=80", description: "Organic Baby Spinach, 16 oz.", inventory: 19, price: 4.99, active: true)
it_14 = m_07.items.create(name: "Tomato", image: "https://images.unsplash.com/photo-1494220394759-e0b232f883ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=668&q=80", description: "Organic Tomatoes, 1.5 lb.", inventory: 24, price: 3.99, active: true)
it_15 = m_08.items.create(name: "Yellow Bell Pepper", image:"https://images.unsplash.com/photo-1551280601-3b3715db4e77?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1567&q=80", description: "Bell Pepper, One Medium.", inventory: 31, price: 2.29, active: true)

c_01 = m_01.coupons.create(name: "take10", value: 10, coupon_type: 0)
c_02 = m_01.coupons.create(name: "5off", value: 5, coupon_type: 1)
c_03 = m_01.coupons.create(name: "halfoff", value: 50, coupon_type: 0)
c_04 = m_02.coupons.create(name: "dollaroff", value: 1, coupon_type: 1)
c_05 = m_02.coupons.create(name: "save10", value: 10, coupon_type: 1)
c_06 = m_02.coupons.create(name: "take20", value: 20, coupon_type: 0)
c_07 = m_03.coupons.create(name: "take30", value: 30, coupon_type: 0)
c_08 = m_03.coupons.create(name: "save5", value: 5, coupon_type: 0)
c_09 = m_04.coupons.create(name: "save15", value: 15, coupon_type: 0)
c_10 = m_04.coupons.create(name: "take2", value: 2, coupon_type: 1)

o_01 = u_01.orders.create(status: 0, created_at: 10.days.ago, updated_at: 5.days.ago)
oi_01 = OrderItem.create(order_id: o_01.id, item_id: it_01.id, price: 0.50, quantity: 3, fulfilled: false, created_at: 10.days.ago, updated_at: 5.days.ago)
oi_02 = OrderItem.create(order_id: o_01.id, item_id: it_02.id, price: 1.42, quantity: 4, fulfilled: false, created_at: 10.days.ago, updated_at: 7.days.ago)

o_02 = u_02.orders.create(status: 1, created_at: 5.days.ago, updated_at: 2.days.ago)
oi_03 = OrderItem.create(order_id: o_02.id, item_id: it_03.id, price: 1.79, quantity: 2, fulfilled: false, created_at: 5.days.ago, updated_at: 2.days.ago)

o_03 = u_03.orders.create(status: 2, created_at: 6.days.ago, updated_at: 5.days.ago)
oi_04 = OrderItem.create(order_id: o_03.id, item_id: it_04.id, price: 2.99, quantity: 5, fulfilled: true, created_at: 6.days.ago, updated_at: 5.days.ago)
oi_05 = OrderItem.create(order_id: o_03.id, item_id: it_05.id, price: 3.99, quantity: 2, fulfilled: true, created_at: 6.days.ago, updated_at: 5.days.ago)

o_04 = u_04.orders.create(status: 3, created_at: 7.days.ago, updated_at: 4.days.ago)
oi_06 = OrderItem.create(order_id: o_04.id, item_id: it_06.id, price: 2.99, quantity: 3, fulfilled: false, created_at: 7.days.ago, updated_at: 4.days.ago)

o_05 = u_05.orders.create(status: 0, created_at: 9.days.ago, updated_at: 3.days.ago)
oi_07 = OrderItem.create(order_id: o_05.id, item_id: it_07.id, price: 0.99, quantity: 2, fulfilled: false, created_at: 9.days.ago, updated_at: 3.days.ago)
oi_08 = OrderItem.create(order_id: o_05.id, item_id: it_08.id, price: 1.99, quantity: 3, fulfilled: false, created_at: 9.days.ago, updated_at: 7.days.ago)
oi_09 = OrderItem.create(order_id: o_05.id, item_id: it_09.id, price: 2.99, quantity: 7, fulfilled: false, created_at: 9.days.ago, updated_at: 8.days.ago)

o_06 = u_06.orders.create(status: 1, created_at: 12.days.ago, updated_at: 11.days.ago)
oi_10 = OrderItem.create(order_id: o_06.id, item_id: it_10.id, price: 0.79, quantity: 3, fulfilled: false, created_at: 12.days.ago, updated_at: 11.days.ago)
oi_11 = OrderItem.create(order_id: o_06.id, item_id: it_11.id, price: 2.50, quantity: 5, fulfilled: false, created_at: 12.days.ago, updated_at: 11.days.ago)

o_07 = u_07.orders.create(status: 2, created_at: 4.days.ago, updated_at: 3.days.ago)
oi_12 = OrderItem.create(order_id: o_07.id, item_id: it_12.id, price: 2.99, quantity: 2, fulfilled: true, created_at: 4.days.ago, updated_at: 3.days.ago)
oi_13 = OrderItem.create(order_id: o_07.id, item_id: it_13.id, price: 4.99, quantity: 1, fulfilled: true, created_at: 4.days.ago, updated_at: 3.days.ago)

o_08 = u_08.orders.create(status: 3, created_at: 6.days.ago, updated_at: 5.days.ago)
oi_14 = OrderItem.create(order_id: o_08.id, item_id: it_14.id, price: 3.99, quantity: 7, fulfilled: false, created_at: 6.days.ago, updated_at: 5.days.ago)
oi_15 = OrderItem.create(order_id: o_08.id, item_id: it_15.id, price: 2.29, quantity: 2, fulfilled: false, created_at: 6.days.ago, updated_at: 5.days.ago)

o_09 = u_09.orders.create(status: 0, created_at: 1.day.ago, updated_at: 1.day.ago)
oi_16 = OrderItem.create(order_id: o_09.id, item_id: it_01.id, price: 0.50, quantity: 3, fulfilled: false, created_at: 1.day.ago, updated_at: 1.day.ago)
oi_17 = OrderItem.create(order_id: o_09.id, item_id: it_02.id, price: 1.42, quantity: 5, fulfilled: false, created_at: 1.day.ago, updated_at: 1.day.ago)

o_10 = u_10.orders.create(status: 1, created_at: 3.days.ago, updated_at: 1.day.ago)
oi_18 = OrderItem.create(order_id: o_10.id, item_id: it_03.id, price: 1.79, quantity: 5, fulfilled: false, created_at: 3.days.ago, updated_at: 1.day.ago)

o_11 = u_01.orders.create(status: 2, created_at: 4.days.ago, updated_at: 2.days.ago)
oi_19 = OrderItem.create(order_id: o_11.id, item_id: it_01.id, price: 0.50, quantity: 3, fulfilled: true, created_at: 4.days.ago, updated_at: 3.days.ago)
oi_20 = OrderItem.create(order_id: o_11.id, item_id: it_02.id, price: 1.42, quantity: 4, fulfilled: true, created_at: 4.days.ago, updated_at: 2.days.ago)

o_12 = u_02.orders.create(status: 2, created_at: 10.days.ago, updated_at: 8.days.ago)
oi_21 = OrderItem.create(order_id: o_12.id, item_id: it_03.id, price: 1.79, quantity: 2, fulfilled: true, created_at: 10.days.ago, updated_at: 8.days.ago)

o_13 = u_04.orders.create(status: 2, created_at: 5.days.ago, updated_at: 1.day.ago)
oi_22 = OrderItem.create(order_id: o_13.id, item_id: it_06.id, price: 2.99, quantity: 3, fulfilled: true, created_at: 5.days.ago, updated_at: 1.day.ago)

o_14 = u_05.orders.create(status: 2, created_at: 3.days.ago, updated_at: 1.hour.ago)
oi_23 = OrderItem.create(order_id: o_14.id, item_id: it_07.id, price: 0.99, quantity: 2, fulfilled: true, created_at: 10.days.ago, updated_at: 2.days.ago)
oi_24 = OrderItem.create(order_id: o_14.id, item_id: it_08.id, price: 1.99, quantity: 3, fulfilled: true, created_at: 10.days.ago, updated_at: 10.hours.ago)
oi_25 = OrderItem.create(order_id: o_14.id, item_id: it_09.id, price: 2.99, quantity: 7, fulfilled: true, created_at: 10.days.ago, updated_at: 2.hours.ago)
