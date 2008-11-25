document.observe('dom:loaded', function() {
  $$('input[type=submit].delete').each(function(b) {
    b.onclick = null
    b.observe('click', function(e) {
      e.stop()
      if(confirm('Are you sure?')) {
        new Ajax.Request(b.form.action, {
          parameters: b.form.serialize(),
          onComplete: function(response) {
            eval('total = '+response.responseText);
            b.up('tbody').down('td.total').innerHTML = number_to_currency(total)
            b.up('tr').remove()
          }
        })
      }
    })
  })
  
  $('clock_in').observe('click', function(e) {
    e.stop()
    new Ajax.Updater('new_line_items', this.form.action, {
      parameters: this.form.serialize(),
      insertion: 'after'
    })
  })
  
  $$('.clock_out').each(function(a) {
    a.observe('click', function(e) {
      e.stop()
      new Ajax.Request(a.href, {
        onComplete: function(response) {
          eval('object = '+response.responseText);
          a.up('tr').replace(object.line_item)
          b.up('tbody').down('td.total').innerHTML = number_to_currency(object.total)
        }
      })
    })
  })
})
