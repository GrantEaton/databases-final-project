$(document).ready(function() {

  let user = localStorage.getItem('user')

  if (user) {

    $('body').addClass('authed')

    $('form').append('<input name="user" value='+user+' hidden />')

  }

  $('#signup').submit(function(e) {

    e.preventDefault()

    let data = $(this).serializeArray().reduce((obj, next) => {

      obj[next.name] = next.value

      return obj

    }, {})

    axios.post('/users', data)
      .then(response => {
        localStorage.setItem('user', response.data.id)
        location = '/profile'
      })

  })

  $('#login').submit(function(e) {

    e.preventDefault()

    let data = $(this).serializeArray().reduce((obj, next) => {

      obj[next.name] = next.value

      return obj

    }, {})

    console.log(data)

    axios.post('/login', data)
      .then(response => {
        let id = response.data.id;

        if (id) {
          localStorage.setItem('user', id)
          location = '/profile'
        } else {

        }

      })

  })

})
