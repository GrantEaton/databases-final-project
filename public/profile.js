$(document).ready(function() {

  axios.get('/profile/'+localStorage.getItem('user'))
    .then(response => {
      $('.container').append(response.data.html)
    })

})
