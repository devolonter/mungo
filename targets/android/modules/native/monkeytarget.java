
class BBMonkeyGame extends BBAndroidGame{

	public BBMonkeyGame( AndroidGame game,AndroidGame.GameView view ){
		super( game,view );
	}
}

public class MonkeyGame extends AndroidGame{

	public static class GameView extends AndroidGame.GameView{

		public GameView( Context context ){
			super( context );
		}
		
		public GameView( Context context,AttributeSet attrs ){
			super( context,attrs );
		}
	}
	
	@Override
	public void onCreate( Bundle savedInstanceState ){
		super.onCreate( savedInstanceState );
		
		setContentView( R.layout.main );
		
		_view=(GameView)findViewById( R.id.gameView );
		
		_game=new BBMonkeyGame( this,_view );
		
		try{
				
			bb_.bbInit();
			bb_.bbMain();
			
		}catch( RuntimeException ex ){

			_game.Die( ex );

			finish();
		}

		if( _game.Delegate()==null ) finish();
		
		_game.Run();
	}
};
