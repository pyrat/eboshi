Date.prototype.toSQL = function() {
  return this.getFullYear() + '-' +
    (this.getMonth() + 1).toPaddedString(2) + '-' +
    this.getDate().toPaddedString(2) + ' ' +
    this.getHours().toPaddedString(2) + ':' +
    this.getMinutes().toPaddedString(2) + ':' +
    this.getSeconds().toPaddedString(2);
};

function restripe() {
  $$('tbody[id]~=invoice]').each(function(i, index) {
    colors = ['white', '#CCCCCC'].reverse()
    i.style.backgroundColor = colors[index % 2]
  })
}

function select_all(flag) {
	$$('input[type=checkbox]').each(function(checkbox) {
		checkbox.checked = flag
	})
}

