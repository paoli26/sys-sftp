%dw 2.0
fun getDate(timestamp) = 
    if (timestamp != null) 
        (timestamp as Number as DateTime {unit:"seconds"}) as Date 
    else 
        null

fun doMapping(invoices) = invoices.data map ((data, index) -> 
  {
    id: data.id,
    currency:upper(data.currency),
    total:sum(data.lines.data.amount default []),
    date: getDate(data.created),
    customer: 
      {
        id: data.customer,
        city: data.customer_address.city,
        country: data.customer_address.country,
        postalCode: data.customer_address.postal_code as String,
        email:data.customer_email,
        name: data.customer_name,
        phone: data.customer_phone as String,  
      },
    lineItems: data.lines.data map ((lineItems, index) ->
      {
        id: lineItems.id,
        amount: lineItems.amount
      } )
  })