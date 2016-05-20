<!doctype html>
<html lang="en">
 <head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{ title }}</title>
  <link rel="stylesheet" href="{{ cfg.bootstrap_dir }}/css/bootstrap{{ cfg.min_suffix }}.css">
  <link rel="stylesheet" href="{{ cfg.bootstrap_dir }}/css/bootstrap-theme{{ cfg.min_suffix }}.css">
  <style>
	/* TODO: move to file */
	/* Custom page footer */
	.footer {
	  padding-top: 19px;
	  color: #777;
	  border-top: 1px solid #e5e5e5;
	}
  </style>
 </head>
 <body>

  <nav class="navbar navbar-default navbar-inverse">
      <div class="container-fluid">
        <div class="navbar-header">
	  <span class="navbar-brand">WebSocket Demo</span>
        </div>
        <div id="navbar" class="collapse navbar-collapse">
          <ul class="nav navbar-nav">
            <li><a href="https://github.com/hpaluch/websocket-jq-openshift" target="github">Source on GitHub.com</a></li>
          </ul>
        </div><!-- /.nav-collapse -->
      </div><!-- /.container-fluid -->
  </nav><!-- /.navbar -->

  <div class="container">
    <div class="row">
      <div class="span12">
	<div class="jumbotron">
			<h1>{{ title }}</h1>
			<p class="lead">Demo of WebSockets with node.js, Express, 
			   Swig templates and jQuery.
			</p>
                        <p><a href="https://github.com/hpaluch/websocket-jq-openshift" target="github" class="btn btn-lg btn-success" role="button">Source on GitHub</a></p>
	</div><!--/.jambotron-->

     </div><!-- /.span12 -->
   </div><!-- /.row -->

    <div class="row">
      <div class="col-sm-6">
<div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">WebSocket data from <span id="wsInfo"></span></h3>
            </div>
            <div class="panel-body">
		<ul id='wsData'>
			<li></li>
			<li></li>
			<li></li>
			<li></li>
			<li></li>
		</ul>
            </div>
          </div>
      </div>
      <div class="col-sm-6">
<div class="panel panel-default">
            <div class="panel-heading">
              <h3 class="panel-title">Some future panel</h3>
            </div>
            <div class="panel-body">
		<p>Some future content</p>
            </div>
          </div>
     </div><!-- /.span12 -->
 
   </div><!-- /.row -->

   <footer class="footer">
	<p>Page last modified on: {{ serverDate }}</p>
   </footer>
 </div><!-- /.container -->

        <script src="{{ cfg.jquery_dir }}/js/jquery{{ cfg.min_suffix }}.js"></script>
        <script src="{{ cfg.bootstrap_dir }}/js/bootstrap{{ cfg.min_suffix }}.js"></script>
	<script>
		$(document).ready(function() {
			if(!("WebSocket" in window)){
				alert('Sorry - this page requires WebSocket!');
				return;
			}
			document.myCounter = 0;
			var host = location.origin.replace(/^http/, 'ws');
{% if cfg.isOpenShift %}
			// WebSockets must connect to port 8000 on OpenShift
			var parser = document.createElement('a');
		        parser.href = host;
		        host = parser.protocol+"//"+parser.hostname+":8000";
{% endif %}
			$('#wsInfo').text(host);

			var ws = new WebSocket(host);
			ws.onmessage = function (event) {
                           var text = JSON.parse(event.data);
			   $('#wsData').append(
				$('<li>').text('Response #'+(++document.myCounter)+' '+text)
			   );
			   var n = $('#wsData li').length;
			   if ( n > 5 ){
				 // scroll up data to avoid memory/DOM leaks...
				 $('#wsData li:first-child').remove();
			   }
			};
			ws.onclose = function (event) {
				alert('WebSocket closed!');
			};
		});
	</script>
 </body>
</html>



