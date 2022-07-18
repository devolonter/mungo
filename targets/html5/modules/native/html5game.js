
var webglGraphicsSeq=1;

function BBHtml5Game( canvas ){
	BBGame.call( this );
	BBHtml5Game._game=this;
	this._canvas=canvas;
	this._loading=0;
	this._timerSeq=0;
	this._gl=null;
	this._location = document.createElement('a');

	if( (CFG_OPENGL_GLES20_ENABLED=="1" || CFG_HTML5_WEBGL_ENABLED=="1") && window.WebGLRenderingContext){
		this.InitWebGL();

		if (this._gl) {
			var lostContextEvent = document.createEvent('Event');
			lostContextEvent.initEvent("bb::lostglcontext", false, false);

			canvas.addEventListener(
				'webglcontextlost',
				function(event) {
					event.preventDefault();
					this.SuspendGame();
				}.bind(this),
				false
			);

			canvas.addEventListener(
				'webglcontextrestored',
				function(event) {
					event.preventDefault();
					++webglGraphicsSeq;
					this.InitWebGL();
					document.dispatchEvent(lostContextEvent);
					this.ResumeGame();
				}.bind(this),
				false
			);
		}
	}

	if (typeof CFG_MOJO_IMAGE_FILTERING_ENABLED !== "undefined"	&& CFG_MOJO_IMAGE_FILTERING_ENABLED === "0"){
		canvas.style['image-rendering'] = 'optimizeSpeed';
		canvas.style['image-rendering'] = 'crisp-edges';
		canvas.style['image-rendering'] = '-moz-crisp-edges';
		canvas.style['image-rendering'] = '-webkit-optimize-contrast';
		canvas.style['image-rendering'] = 'optimize-contrast';
		canvas.style.msInterpolationMode = 'nearest-neighbor';
	}

	// --- start gamepad api by skn3 ---------
	this._gamepads = null;
	this._gamepadLookup = [-1,-1,-1,-1];//support 4 gamepads
	var that = this;
	window.addEventListener("gamepadconnected", function(e) {
		that.connectGamepad(e.gamepad);
	});

	window.addEventListener("gamepaddisconnected", function(e) {
		that.disconnectGamepad(e.gamepad);
	});

	//need to process already connected gamepads (before page was loaded)
	var gamepads = this.getGamepads();
	if (gamepads && gamepads.length > 0) {
		for(var index=0;index < gamepads.length;index++) {
			this.connectGamepad(gamepads[index]);
		}
	}
	// --- end gamepad api by skn3 ---------
}

BBHtml5Game.prototype=extend_class( BBGame );

BBHtml5Game.Html5Game=function(){
	return BBHtml5Game._game;
}

BBHtml5Game.EatEvent = function( e ){
	if( e.stopPropagation ){
		e.stopPropagation();
		e.preventDefault();
	}else{
		e.cancelBubble=true;
		e.returnValue=false;
	}
}

// --- start gamepad api by skn3 ---------
BBHtml5Game.prototype.getGamepads = function() {
	return navigator.getGamepads ? navigator.getGamepads() : (navigator.webkitGetGamepads ? navigator.webkitGetGamepads : []);
}

BBHtml5Game.prototype.connectGamepad = function(gamepad) {
	if (!gamepad) {
		return false;
	}

	//check if this is a standard gamepad
	if (gamepad.mapping == "standard") {
		//yup so lets add it to an array of valid gamepads
		//find empty controller slot
		var slot = -1;
		for(var index = 0;index < this._gamepadLookup.length;index++) {
			if (this._gamepadLookup[index] == -1) {
				slot = index;
				break;
			}
		}

		//can we add this?
		if (slot != -1) {
			this._gamepadLookup[slot] = gamepad.index;

			//console.log("gamepad at html5 index "+gamepad.index+" mapped to monkey gamepad unit "+slot);
		}
	} else {
		console.log('Monkey has ignored gamepad at raw port #'+gamepad.index+' with unrecognised mapping scheme \''+gamepad.mapping+'\'.');
	}
}

BBHtml5Game.prototype.disconnectGamepad = function(gamepad) {
	if (!gamepad) {
		return false;
	}

	//scan all gamepads for matching index
	for(var index = 0;index < this._gamepadLookup.length;index++) {
		if (this._gamepadLookup[index] == gamepad.index) {
			//remove this gamepad
			this._gamepadLookup[index] = -1
			break;
		}
	}
}

BBHtml5Game.prototype.PollJoystick=function(port, joyx, joyy, joyz, buttons){
	//is this the first gamepad being polled
	if (port == 0) {
		//yes it is so we use the web api to get all gamepad info
		//we can then use this in subsequent calls to PollJoystick
		this._gamepads = this.getGamepads();
	}

	//dont bother processing if nothing to process
	if (!this._gamepads) {
	  return false;
	}

	//so use the monkey port to find the correct raw data
	var index = this._gamepadLookup[port];
	if (index == -1) {
		return false;
	}

	var gamepad = this._gamepads[index];
	if (!gamepad) {
		return false;
	}
	//so now process gamepad axis/buttons according to the standard mappings
	//https://w3c.github.io/gamepad/#remapping

	//left stick axis
	joyx[0] = gamepad.axes[0];
	joyy[0] = -gamepad.axes[1];

	//right stick axis
	joyx[1] = gamepad.axes[2];
	joyy[1] = -gamepad.axes[3];

	//left trigger
	joyz[0] = gamepad.buttons[6] ? gamepad.buttons[6].value : 0.0;

	//right trigger
	joyz[1] = gamepad.buttons[7] ? gamepad.buttons[7].value : 0.0;

	//clear button states
	for(var index = 0;index <32;index++) {
		buttons[index] = false;
	}

	//map html5 "standard" mapping to monkeys joy codes
	/*
	Const JOY_A=0
	Const JOY_B=1
	Const JOY_X=2
	Const JOY_Y=3
	Const JOY_LB=4
	Const JOY_RB=5
	Const JOY_BACK=6
	Const JOY_START=7
	Const JOY_LEFT=8
	Const JOY_UP=9
	Const JOY_RIGHT=10
	Const JOY_DOWN=11
	Const JOY_LSB=12
	Const JOY_RSB=13
	Const JOY_MENU=14
	*/
	buttons[0] = gamepad.buttons[0] && gamepad.buttons[0].pressed;
	buttons[1] = gamepad.buttons[1] && gamepad.buttons[1].pressed;
	buttons[2] = gamepad.buttons[2] && gamepad.buttons[2].pressed;
	buttons[3] = gamepad.buttons[3] && gamepad.buttons[3].pressed;
	buttons[4] = gamepad.buttons[4] && gamepad.buttons[4].pressed;
	buttons[5] = gamepad.buttons[5] && gamepad.buttons[5].pressed;
	buttons[6] = gamepad.buttons[8] && gamepad.buttons[8].pressed;
	buttons[7] = gamepad.buttons[9] && gamepad.buttons[9].pressed;
	buttons[8] = gamepad.buttons[14] && gamepad.buttons[14].pressed;
	buttons[9] = gamepad.buttons[12] && gamepad.buttons[12].pressed;
	buttons[10] = gamepad.buttons[15] && gamepad.buttons[15].pressed;
	buttons[11] = gamepad.buttons[13] && gamepad.buttons[13].pressed;
	buttons[12] = gamepad.buttons[10] && gamepad.buttons[10].pressed;
	buttons[13] = gamepad.buttons[11] && gamepad.buttons[11].pressed;
	buttons[14] = gamepad.buttons[16] && gamepad.buttons[16].pressed;

	//success
	return true
}
// --- end gamepad api by skn3 ---------

BBHtml5Game.prototype.InitWebGL=function(){
	var options;

	if (CFG_HTML5_WEBGL_ENABLED=="1") {
		options = {
			alpha: false,
			premultipliedAlpha: CFG_OPENGL_GLES20_ENABLED=="0",
			antialias: (typeof CFG_MOJO_IMAGE_FILTERING_ENABLED === "undefined" || CFG_MOJO_IMAGE_FILTERING_ENABLED === "1")
		};
	} else {
		options = {
			antialias: true,
			preserveDrawingBuffer: false
		};
	}

	this._gl=this._canvas.getContext( "webgl", options);
	if( !this._gl ) this._gl=this._canvas.getContext( "experimental-webgl", options);
	if( !this._gl && CFG_OPENGL_GLES20_ENABLED=="1" ) this.Die( "Can't create WebGL" );

	window['gl']=this._gl;
};

BBHtml5Game.prototype.ValidateUpdateTimer=function(){

	++this._timerSeq;
	if( this._suspended ) return;

	var game=this;
	var seq=game._timerSeq;

	var maxUpdates=4;
	var updateRate=this._updateRate;

	var reqAnimFrame=(window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame || window.oRequestAnimationFrame || window.msRequestAnimationFrame);

	if( !updateRate ){
		if( reqAnimFrame ){
			function animate(){
				if( seq!=game._timerSeq ) return;

				game.UpdateGame();
				if( seq!=game._timerSeq ) return;

				reqAnimFrame( animate );
				game.RenderGame();
			}
			reqAnimFrame( animate );
			return;
		}

		maxUpdates=1;
		updateRate=60;
	}

	var updatePeriod=1000.0/updateRate;

	if (!reqAnimFrame) {
		var nextUpdate=0;

		function timeElapsed(){
			if( seq!=game._timerSeq ) return;

			if( !nextUpdate ) nextUpdate=Date.now();

			for( var i=0;i<maxUpdates;++i ){

				game.UpdateGame();
				if( seq!=game._timerSeq ) return;

				nextUpdate+=updatePeriod;
				var delay=nextUpdate-Date.now();

				if( delay>0 ){
					setTimeout( timeElapsed,delay );
					game.RenderGame();
					return;
				}
			}
			nextUpdate=0;
			setTimeout( timeElapsed,0 );
			game.RenderGame();
		}

		setTimeout( timeElapsed,0 );
	} else {
		var now = 0;
		var then = Date.now();
		var delta = 0;

		function modernTimeElapsed(){
			if( seq!=game._timerSeq ) return;
			reqAnimFrame(modernTimeElapsed);

			now = Date.now();
			delta = now - then;

			if (delta > updatePeriod) {
				for( var i=0;i<maxUpdates;++i ){
					game.UpdateGame();
					if( seq!=game._timerSeq ) return;

					delta-=updatePeriod;
					if (delta < updatePeriod) break;
				}

				then = now - (delta % updatePeriod);
				game.RenderGame();
			}
		}

		modernTimeElapsed();
	}
}

//***** BBGame methods *****

BBHtml5Game.prototype.SetUpdateRate=function( updateRate ){

	BBGame.prototype.SetUpdateRate.call( this,updateRate );

	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.GetMetaData=function( path,key ){
	if( path.indexOf( "monkey://data/" )!=0 ) return "";
	path=path.slice(14);

	var i=META_DATA.indexOf( "["+path+"]" );
	if( i==-1 ) return "";
	i+=path.length+2;

	var e=META_DATA.indexOf( "\n",i );
	if( e==-1 ) e=META_DATA.length;

	i=META_DATA.indexOf( ";"+key+"=",i )
	if( i==-1 || i>=e ) return "";
	i+=key.length+2;

	e=META_DATA.indexOf( ";",i );
	if( e==-1 ) return "";

	return META_DATA.slice( i,e );
}

BBHtml5Game.prototype.PathToUrl=function( path ){
	if( path.indexOf( "monkey:" )!=0 ){
		return path;
	}else if( path.indexOf( "monkey://data/" )==0 ) {
		return "data/"+path.slice( 14 );
	}
	return "";
}

BBHtml5Game.prototype.IsCrossOriginUrl=function( url ){
	this._location.href = url;
	return this._location.hostname !== window.location.hostname;
}

BBHtml5Game.prototype.LoadAudioData=function( path,listener ){
	if (window['PRELOADER_CACHE'] && window['PRELOADER_CACHE']['AUDIO'][path]) {
		listener(window['PRELOADER_CACHE']['AUDIO'][path]);
	} else {
		var req=new XMLHttpRequest();

		req.open( "get",path,true );
		req.responseType="arraybuffer";

		var abuf=this;

		req.onload=function(){
			wa.decodeAudioData( req.response,function( buffer ){
				listener(buffer);
			}, function(){
				listener(null);
			});
		}

		req.onerror=function(){
			listener(null);
		}

		req.send();
	}
}

BBHtml5Game.prototype.GetLoading=function(){
	return this._loading;
}

BBHtml5Game.prototype.IncLoading=function(){
	++this._loading;
	return this._loading;
}

BBHtml5Game.prototype.DecLoading=function(){
	--this._loading;
	return this._loading;
}

BBHtml5Game.prototype.GetCanvas=function(){
	return this._canvas;
}

BBHtml5Game.prototype.GetWebGL=function(){
	return this._gl;
}

BBHtml5Game.prototype.GetDeviceWidth=function(){
	return this._canvas.width;
}

BBHtml5Game.prototype.GetDeviceHeight=function(){
	return this._canvas.height;
}

//***** INTERNAL *****

BBHtml5Game.prototype.UpdateGame=function(){

	if( !this._loading ) BBGame.prototype.UpdateGame.call( this );
}

BBHtml5Game.prototype.SuspendGame=function(){

	BBGame.prototype.SuspendGame.call( this );

	BBGame.prototype.RenderGame.call( this );

	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.ResumeGame=function(){

	BBGame.prototype.ResumeGame.call( this );

	this.ValidateUpdateTimer();
}

BBHtml5Game.prototype.Run=function(){

	var game=this;
	var canvas=game._canvas;

	var xscale=1;
	var yscale=1;

	var touchIds=new Array( 32 );
	for(var i=0;i<32;++i ) touchIds[i]=-1;

	function keyToChar( key ){
		switch( key ){
		case 8:case 9:case 13:case 27:case 32:return key;
		case 33:case 34:case 35:case 36:case 37:case 38:case 39:case 40:case 45:return key|0x10000;
		case 46:return 127;
		}
		return 0;
	}

	function mouseX( e ){
		var x=e.clientX+document.body.scrollLeft;
		var c=canvas;
		while( c ){
			x-=c.offsetLeft;
			c=c.offsetParent;
		}
		return x*xscale;
	}

	function mouseY( e ){
		var y=e.clientY+document.body.scrollTop;
		var c=canvas;
		while( c ){
			y-=c.offsetTop;
			c=c.offsetParent;
		}
		return y*yscale;
	}

	function touchX( touch ){
		var x=touch.pageX;
		var c=canvas;
		while( c ){
			x-=c.offsetLeft;
			c=c.offsetParent;
		}
		return x*xscale;
	}

	function touchY( touch ){
		var y=touch.pageY;
		var c=canvas;
		while( c ){
			y-=c.offsetTop;
			c=c.offsetParent;
		}
		return y*yscale;
	}

	canvas.onkeydown=function( e ){
		game.KeyEvent( BBGameEvent.KeyDown,e.keyCode );
		var chr=keyToChar( e.keyCode );
		if( chr ) game.KeyEvent( BBGameEvent.KeyChar,chr );
		if( e.keyCode<48 || (e.keyCode>111 && e.keyCode<122) ) BBHtml5Game.EatEvent( e );
	}

	canvas.onkeyup=function( e ){
		game.KeyEvent( BBGameEvent.KeyUp,e.keyCode );
	}

	canvas.onkeypress=function( e ){
		if( e.charCode ){
			game.KeyEvent( BBGameEvent.KeyChar,e.charCode );
		}else if( e.which ){
			game.KeyEvent( BBGameEvent.KeyChar,e.which );
		}
	}

	canvas.onmousedown=function( e ){
		switch( e.button ){
		case 0:game.MouseEvent( BBGameEvent.MouseDown,0,mouseX(e),mouseY(e) );break;
		case 1:game.MouseEvent( BBGameEvent.MouseDown,2,mouseX(e),mouseY(e) );break;
		case 2:game.MouseEvent( BBGameEvent.MouseDown,1,mouseX(e),mouseY(e) );break;
		}
		BBHtml5Game.EatEvent( e );
	}

	canvas.onmouseup=function( e ){
		switch( e.button ){
		case 0:game.MouseEvent( BBGameEvent.MouseUp,0,mouseX(e),mouseY(e) );break;
		case 1:game.MouseEvent( BBGameEvent.MouseUp,2,mouseX(e),mouseY(e) );break;
		case 2:game.MouseEvent( BBGameEvent.MouseUp,1,mouseX(e),mouseY(e) );break;
		}
		BBHtml5Game.EatEvent( e );
	}

	canvas.onmousemove=function( e ){
		game.MouseEvent( BBGameEvent.MouseMove,-1,mouseX(e),mouseY(e) );
		BBHtml5Game.EatEvent( e );
	}

	canvas.onmouseout=function( e ){
		game.MouseEvent( BBGameEvent.MouseUp,0,mouseX(e),mouseY(e) );
		game.MouseEvent( BBGameEvent.MouseUp,1,mouseX(e),mouseY(e) );
		game.MouseEvent( BBGameEvent.MouseUp,2,mouseX(e),mouseY(e) );
		BBHtml5Game.EatEvent( e );
	}

	canvas.onclick=function( e ){
		if( game.Suspended() ){
			canvas.focus();
		}
		BBHtml5Game.EatEvent( e );
		return;
	}

	canvas.oncontextmenu=function( e ){
		return false;
	}

	canvas.ontouchstart=function( e ){
		if( game.Suspended() ){
			canvas.focus();
		}
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=-1 ) continue;
				touchIds[j]=touch.identifier;
				game.TouchEvent( BBGameEvent.TouchDown,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		BBHtml5Game.EatEvent( e );
	}

	canvas.ontouchmove=function( e ){
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=touch.identifier ) continue;
				game.TouchEvent( BBGameEvent.TouchMove,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		BBHtml5Game.EatEvent( e );
	}

	canvas.ontouchend=function( e ){
		for( var i=0;i<e.changedTouches.length;++i ){
			var touch=e.changedTouches[i];
			for( var j=0;j<32;++j ){
				if( touchIds[j]!=touch.identifier ) continue;
				touchIds[j]=-1;
				game.TouchEvent( BBGameEvent.TouchUp,j,touchX(touch),touchY(touch) );
				break;
			}
		}
		BBHtml5Game.EatEvent( e );
	}

	window.ondevicemotion=function( e ){
		var tx=e.accelerationIncludingGravity.x/9.81;
		var ty=e.accelerationIncludingGravity.y/9.81;
		var tz=e.accelerationIncludingGravity.z/9.81;
		var x,y;
		switch( window.orientation ){
		case   0:x=+tx;y=-ty;break;
		case 180:x=-tx;y=+ty;break;
		case  90:x=-ty;y=-tx;break;
		case -90:x=+ty;y=+tx;break;
		}
		game.MotionEvent( BBGameEvent.MotionAccel,0,x,y,tz );
		BBHtml5Game.EatEvent( e );
	}

	canvas.onfocus=function( e ){
		if( CFG_MOJO_AUTO_SUSPEND_ENABLED=="1" ){
			game.ResumeGame();
		}else{
			game.ValidateUpdateTimer();
 		}
	}

	canvas.onblur=function( e ){
		for( var i=0;i<256;++i ) game.KeyEvent( BBGameEvent.KeyUp,i );
		if( CFG_MOJO_AUTO_SUSPEND_ENABLED=="1" ){
			game.SuspendGame();
		}
	}

	canvas['updateSize']=canvas.updateSize=function(){
		xscale=canvas.width/canvas.clientWidth;
		yscale=canvas.height/canvas.clientHeight;
		game.RenderGame();
	}

	if( CFG_MOJO_AUTO_SUSPEND_ENABLED=="0" && typeof CFG_HTML5_KEEP_APP_ACTIVE!=='undefined' && CFG_HTML5_KEEP_APP_ACTIVE=="1" && typeof Worker!=='undefined' && typeof Blob!=='undefined'){
		var hidden, visibilityChange, worker;
		if (typeof document.hidden !== "undefined") {
			hidden = "hidden";
			visibilityChange = "visibilitychange";
		} else if (typeof document.mozHidden !== "undefined") {
			hidden = "mozHidden";
			visibilityChange = "mozvisibilitychange";
		} else if (typeof document.msHidden !== "undefined") {
			hidden = "msHidden";
			visibilityChange = "msvisibilitychange";
		} else if (typeof document.webkitHidden !== "undefined") {
			hidden = "webkitHidden";
			visibilityChange = "webkitvisibilitychange";
		}

		function handleVisibilityChange() {
			if (document[hidden]) {
				var step = game._updateRate > 0 ? (1000 / game._updateRate)|0 : 17;

				var blob = new Blob( ['setInterval(function(){postMessage(null)}, ' + step + ')'] );
				worker = new Worker( window.URL.createObjectURL(blob) );

				worker.onmessage = function ( e ) {
					game.UpdateGame();
					game.RenderGame();
				}
			} else {
				worker.terminate();
			}
		}

		document.addEventListener(visibilityChange, handleVisibilityChange, false);
	}

	canvas.updateSize();

	canvas.focus();

	game.StartGame();

	game.RenderGame();
}
