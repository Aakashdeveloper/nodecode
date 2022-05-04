let express = require('express');
let app = express();
let port = 7600;

//default route
app.get('/',function(req,res){
    res.send('<h1>Hiii From express route</h1>')
})

app.get('/location',function(req,res){
    res.send('You are on location route')
})

app.listen(port, function(err){
    if(err) throw err;
    else{
        console.log('Server is running on port 7600')
    }
})