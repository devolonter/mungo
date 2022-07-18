
function IsMojoAssetExists(path) {
	return BBHtml5Game.Html5Game().GetMetaData( path,"type" ) !== '';
}
