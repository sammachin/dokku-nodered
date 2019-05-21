var xkcdpass = require('xkcdpass');
var config = {plan : [['word'], ['word'], ['word'], ['word']]}
var pass = xkcdpass.generate(config);
console.log(pass)


