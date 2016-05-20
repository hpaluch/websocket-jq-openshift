<!doctype html>
<html lang="en">
 <head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>{{ title }}</title>
  <link rel="stylesheet" href="{{ cfg.bootstrap_dir }}/css/bootstrap{{ cfg.min_suffix }}.css">
  <link rel="stylesheet" href="{{ cfg.bootstrap_dir }}/css/bootstrap-theme{{ cfg.min_suffix }}.css">
 </head>
 <body>
	<h1>{{ title }}</h1>
	<p>Demo of WebSockets with node.js, Express, 
	   Swig templates and jQuery.
	   Please see <a href="https://github.com/hpaluch/websocket-jq-openshift" target="github">Source on GitHub</a>.
	</p>

	<h3>WebSocket data from <span id="wsInfo"></span></h3>
	<ul id='wsData'></ul>

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
			   if ( n > 10 ){
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



