$(document).ready(function() {

  axios.get('/inbox/'+localStorage.getItem('user')+location.search)
    .then(response => {
      $('.container').append(response.data.html)
    })

})
