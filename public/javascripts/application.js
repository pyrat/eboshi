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

function number_to_currency(number, options) {
  try {
    var options   = options || {};
    var precision = options["precision"] || 2;
    var unit      = options["unit"] || "$";
    var separator = precision > 0 ? options["separator"] || "." : "";
    var delimiter = options["delimiter"] || ",";
 
    var parts = parseFloat(number).toFixed(precision).split('.');
    return unit + number_with_delimiter(parts[0], delimiter) + separator + parts[1].toString();
  } catch(e) {
    return number
  }
}

function number_with_delimiter(number, delimiter, separator) {
  try {
    var delimiter = delimiter || ",";
    var separator = separator || ".";
    
    var parts = number.toString().split('.');
    parts[0] = parts[0].replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1" + delimiter);
    return parts.join(separator);
  } catch(e) {
    return number
  }
}

