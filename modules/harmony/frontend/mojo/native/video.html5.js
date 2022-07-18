
function MojoVideoDelegate(){}

MojoVideoDelegate.prototype =
{
  Playing: function(video){};
  Timeupdate: function(video){};
};

function MojoVideoClip(){
  this._video = document.createElement('video');
}

MojoVideoClip.prototype =
{
   function SetDelegate(delegate) {
     var video = this._video;

     video.addEventListener('playing', function() {
        delegate.Playing(video);
     }, true);

     video.addEventListener('timeupdate', function() {
        delegate.Timeupdate(video);
     }, true);
   },

  function Load(path)
  {
    this._video.src = BBHtml5Game.Html5Game().PathToUrl(path);
  },

  get autoplay()
  {
    return this._video.autoplay;
  },

  set autoplay(value)
  {
    this._video.autoplay = value;
  },

  get muted()
  {
    return this._video.muted;
  },

  set muted(value)
  {
    this._video.muted = value;
  },

  get loop()
  {
    return this._video.loop;
  },

  set loop(value)
  {
    this._video.loop = value;
  }
};
