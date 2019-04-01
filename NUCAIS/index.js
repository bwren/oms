var express      = require('express');
var jade         = require('jade');
var app          = express();

// set root for static files
app.use(express.static(__dirname));

// set templating engine
app.set('view engine', 'jade');

// tell express where to look for views
app.set('views', __dirname + '/public/views');

// respond to get '/'
app.get('/', function(req, res) {
  res.render('index');
});

// responds to requests for view partials
app.get('/public/views/partials/:name', function(req, res) {
  console.log("incoming partial req");
  var name = req.params.name;
  res.render('partials/' + name);
});

// listen on 8080
app.listen(8080);
console.log('boo-yah 8080!');
