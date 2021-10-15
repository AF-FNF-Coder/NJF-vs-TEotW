package;

import flixel.math.FlxPoint;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.util.FlxTimer;

using StringTools;

/**
 * Loosley based on FlxTypeText lolol
 */
class Alphabet extends FlxSpriteGroup
{
	public var delay:Float = 0.05;
	public var paused:Bool = false;

	// for menu shit
	public var targetY:Float = 0;
	public var isMenuItem:Bool = false;

	public var text:String = "";

	var _finalText:String = "";
	var _curText:String = "";

	public var widthOfWords:Float = FlxG.width;

	var yMulti:Float = 1;

	// custom shit
	// amp, backslash, question mark, apostrophy, comma, angry faic, period
	var lastSprite:AlphaCharacter;
	var xPosResetted:Bool = false;
	var lastWasSpace:Bool = false;

	var listOAlphabets:List<AlphaCharacter> = new List<AlphaCharacter>();

	var splitWords:Array<String> = [];

	var isBold:Bool = false;

	var pastX:Float = 0;
	var pastY:Float  = 0;

	// AF Enjoyer: Variables here to be used later
	var xScale:Float;
	var yScale:Float;
	//var maxWidth:Int;
	//var charHeight:Float;

	// AF Enjoyer: Added 2 more variables, xScale and yScale for resizing text
	public function new(x:Float, y:Float, text:String = "", ?bold:Bool = false, typed:Bool = false, shouldMove:Bool = false, xScale:Float = 1, yScale:Float = 1/*, maxWidth:Int = 0*/)
	{
		pastX = x;
		pastY = y;

		// AF Enjoyer: Have to assign these variables
		this.xScale = xScale;
		this.yScale = yScale;
		//this.maxWidth = maxWidth;

		super(x, y);

		_finalText = text;
		this.text = text;
		isBold = bold;

		if (text != "")
		{
			if (typed)
			{
				startTypedText();
			}
			else
			{
				addText();
			}

		}

		if(FlxG.save.data.antialiasing)
			antialiasing = true;
	}

	public function reType(text, xScale:Float = 1, yScale:Float = 1)
	{
		for (i in listOAlphabets)
			remove(i);
		_finalText = text;
		this.text = text;

		lastSprite = null;

		updateHitbox();

		listOAlphabets.clear();
		x = pastX;
		y = pastY;

		this.xScale = xScale;
		this.yScale = yScale;
		
		addText();
	}

	public function addText()
	{
		//if(maxWidth == 0) {
			doSplitWords();
			var xPos:Float = 0;
			for (character in splitWords)
			{
				// if (character.fastCodeAt() == " ")
				// {
				// }

				if (character == " " || character == "-")
				{
					lastWasSpace = true;
				}

				if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1)
					// if (AlphaCharacter.alphabet.contains(character.toLowerCase()))
				{
					if (lastSprite != null)
					{
						// AF Enjoyer: This is the line that fixes the spacing error when the x position of this class's objects was anything other than 0
						xPos = lastSprite.x - pastX + lastSprite.width;
					}

					if (lastWasSpace)
					{
						// AF Enjoyer: Also this line
						xPos += 40 * xScale;
						lastWasSpace = false;
					}

					// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
					var letter:AlphaCharacter = new AlphaCharacter(xPos, 0);
					
					// AF Enjoyer: These are the lines that change the individual scaling of each character
					letter.scale.set(xScale, yScale);
					letter.updateHitbox();

					listOAlphabets.add(letter);

					if (isBold)
						letter.createBold(character);
					else
					{
						letter.createLetter(character);
					}

					add(letter);

					lastSprite = letter;
				}

				// loopNum += 1;
			}
		/*} else {
			splitWordsForReal();
			var newLinesArray:Array<Int> = new Array();
			var wordNumber:Int = 0;
			var totalWidth:Float = 0;

			// I create le words, examine their width and see if its too high, compared to the max width. If so, add the word position to the newLinesArray (1st position = 1, 2nd = 2, etc)
			for(word in splitWords) {
				wordNumber++;
				var xPos:Float = 0;
				var characters:Array<String> = word.split("");
				lastSprite = null;
				for(character in characters) {
					if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1) {
						if (lastSprite != null) {
							// AF Enjoyer: This is the line that fixes the spacing error when the x position of this class's objects was anything other than 0
							xPos = lastSprite.x - pastX + lastSprite.width;
						}
	
						var letter:AlphaCharacter = new AlphaCharacter(xPos, 0);
						
						// AF Enjoyer: These are the lines that change the individual scaling of each character
						letter.scale.set(xScale, yScale);
						letter.updateHitbox();
	
	
						if (isBold)
							letter.createBold(character);
						else
							letter.createLetter(character);
						
	
						totalWidth += letter.width;
						if(charHeight == 0)
							charHeight = letter.height + 5;

	
						lastSprite = letter;
					}
				}

				totalWidth += 40*xScale;

				if(totalWidth > maxWidth) {
					newLinesArray.push(wordNumber);
					totalWidth = 0;
				}

			}

			// This is where the words are actually created and added to the FlxSpriteGroup thing
			wordNumber = 0;
			var yPositionOffset:Float = 0;
			var xPos:Float = 0;
			for(word in splitWords) {
				lastSprite = null;
				if(wordNumber == 0)
					xPos = 0;
				else
					xPos += 80 * xScale;
				if(newLinesArray.contains(wordNumber)) {
					yPositionOffset += charHeight;
					this.y -= charHeight;
					xPos = 0;
				}
				wordNumber++;
				var characters:Array<String> = word.split("");
				for(character in characters) {
		
					if (AlphaCharacter.alphabet.indexOf(character.toLowerCase()) != -1)
					{
						if (lastSprite != null) {
							// AF Enjoyer: This is the line that fixes the spacing error when the x position of this class's objects was anything other than 0
							xPos = lastSprite.x - pastX + lastSprite.width;
						}
	
						var letter:AlphaCharacter = new AlphaCharacter(xPos, yPositionOffset);
						
						// AF Enjoyer: These are the lines that change the individual scaling of each character
						letter.scale.set(xScale, yScale);
						letter.updateHitbox();
	
						listOAlphabets.add(letter);
	
						if (isBold)
							letter.createBold(character);
						else
							letter.createLetter(character);

						add(letter);
						
	
						lastSprite = letter;
					}
				}
			}
		}*/
	}

	//This splits each character
	function doSplitWords():Void
	{
		splitWords = _finalText.split("");
	}

	//This splits each word
	function splitWordsForReal():Void {
		splitWords = _finalText.split(" ");
	}

	public var personTalking:String = 'gf';

	// AF Enjoyer: THIS FUNCTION ISNT CHANGED! Because i dont use it lol
	public function startTypedText():Void
	{
		_finalText = text;
		doSplitWords();

		// trace(arrayShit);

		var loopNum:Int = 0;

		var xPos:Float = 0;
		var curRow:Int = 0;

		new FlxTimer().start(0.05, function(tmr:FlxTimer)
		{
			// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));
			if (_finalText.fastCodeAt(loopNum) == "\n".code)
			{
				yMulti += 1;
				xPosResetted = true;
				xPos = 0;
				curRow += 1;
			}

			if (splitWords[loopNum] == " ")
			{
				lastWasSpace = true;
			}

			#if (haxe >= "4.0.0")
			var isNumber:Bool = AlphaCharacter.numbers.contains(splitWords[loopNum]);
			var isSymbol:Bool = AlphaCharacter.symbols.contains(splitWords[loopNum]);
			#else
			var isNumber:Bool = AlphaCharacter.numbers.indexOf(splitWords[loopNum]) != -1;
			var isSymbol:Bool = AlphaCharacter.symbols.indexOf(splitWords[loopNum]) != -1;
			#end

			if (AlphaCharacter.alphabet.indexOf(splitWords[loopNum].toLowerCase()) != -1 || isNumber || isSymbol)
				// if (AlphaCharacter.alphabet.contains(splitWords[loopNum].toLowerCase()) || isNumber || isSymbol)

			{
				if (lastSprite != null && !xPosResetted)
				{
					lastSprite.updateHitbox();
					xPos += lastSprite.width + 3;
					// if (isBold)
					// xPos -= 80;
				}
				else
				{
					xPosResetted = false;
				}

				if (lastWasSpace)
				{
					xPos += 20;
					lastWasSpace = false;
				}
				// trace(_finalText.fastCodeAt(loopNum) + " " + _finalText.charAt(loopNum));

				// var letter:AlphaCharacter = new AlphaCharacter(30 * loopNum, 0);
				var letter:AlphaCharacter = new AlphaCharacter(xPos, 55 * yMulti);
				listOAlphabets.add(letter);
				letter.row = curRow;
				if (isBold)
				{
					letter.createBold(splitWords[loopNum]);
				}
				else
				{
					if (isNumber)
					{
						letter.createNumber(splitWords[loopNum]);
					}
					else if (isSymbol)
					{
						letter.createSymbol(splitWords[loopNum]);
					}
					else
					{
						letter.createLetter(splitWords[loopNum]);
					}

					letter.x += 90;
				}

				if (FlxG.random.bool(40))
				{
					var daSound:String = "GF_";
					FlxG.sound.play(Paths.soundRandom(daSound, 1, 4));
				}

				add(letter);

				lastSprite = letter;
			}

			loopNum += 1;

			tmr.time = FlxG.random.float(0.04, 0.09);
		}, splitWords.length);
	}

	override function update(elapsed:Float)
	{
		if (isMenuItem)
		{
			var scaledY = FlxMath.remapToRange(targetY, 0, 1, 0, 1.3);

			y = FlxMath.lerp(y, (scaledY * 120) + (FlxG.height * 0.48), 0.30);
			x = FlxMath.lerp(x, (targetY * 20) + 90, 0.30);
		}

		super.update(elapsed);
	}

	/**
		Ooga booga function for resizing text, with the option of wanting it to have the same midPoint.
		
 		Side note: Do not, EVER, do updateHitbox() unless you are retyping the whole thing. Don't know why, but the position gets retarded if you do that.
	**/
	public function resizeText(xScale:Float, yScale:Float, xStaysCentered:Bool = true, yStaysCentered:Bool = false):Void {
		var oldMidpoint:FlxPoint = this.getMidpoint();
		reType(text, xScale, yScale);
		if(!(xStaysCentered && yStaysCentered)){
			if(xStaysCentered) {
				//I can just use this juicy new function i made
				moveTextToMidpoint(new FlxPoint(oldMidpoint.x, getMidpoint().y));
			}
			if(yStaysCentered) {
				moveTextToMidpoint(new FlxPoint(getMidpoint().x, oldMidpoint.y));
			}
		} else {
			moveTextToMidpoint(new FlxPoint(oldMidpoint.x, oldMidpoint.y));
		}

	}

	/**
		Function used to keep text centered on one point instead of manually having to come up with offsets for each sentence
	**/
	public function moveTextToMidpoint(midpoint:FlxPoint):Void {
		/*
		e.g. You want your midpoint at (100, 100)
		and your text is 200 wide, 50 tall
		then, x = 100 - 200/2, y = 100 - 50/2
		*/
		this.x = midpoint.x - this.width / 2;
		this.y = midpoint.y - this.height / 2;
	}

}

class AlphaCharacter extends FlxSprite
{
	public static var alphabet:String = "abcdefghijklmnopqrstuvwxyz";

	public static var numbers:String = "1234567890";

	public static var symbols:String = "|~#$%()*+-:;<=>@[]^_.,'!? ";

	public var row:Int = 0;

	public function new(x:Float, y:Float)
	{
		super(x, y);
		var tex = Paths.getSparrowAtlas('alphabet');
		frames = tex;
		if(FlxG.save.data.antialiasing)
			{
				antialiasing = true;
			}
	}

	public function createBold(letter:String)
	{
		animation.addByPrefix(letter, letter.toUpperCase() + " bold", 24);
		animation.play(letter);
		updateHitbox();
	}

	public function createLetter(letter:String):Void
	{
		var letterCase:String = "lowercase";
		if (letter.toLowerCase() != letter)
		{
			letterCase = 'capital';
		}

		animation.addByPrefix(letter, letter + " " + letterCase, 24);
		animation.play(letter);
		updateHitbox();

		FlxG.log.add('the row' + row);

		y = (110 - height);
		y += row * 60;
	}

	public function createNumber(letter:String):Void
	{
		animation.addByPrefix(letter, letter, 24);
		animation.play(letter);

		updateHitbox();
	}

	public function createSymbol(letter:String)
	{
		switch (letter)
		{
			case '.':
				animation.addByPrefix(letter, 'period', 24);
				animation.play(letter);
				y += 50;
			case "'":
				animation.addByPrefix(letter, 'apostraphie', 24);
				animation.play(letter);
				y -= 0;
			case "?":
				animation.addByPrefix(letter, 'question mark', 24);
				animation.play(letter);
			case "!":
				animation.addByPrefix(letter, 'exclamation point', 24);
				animation.play(letter);
			case '_':
				animation.addByPrefix(letter, '_', 24);
				animation.play(letter);
				y += 50;
			case "#":
				animation.addByPrefix(letter, '#', 24);
				animation.play(letter);
			case "$":
				animation.addByPrefix(letter, '$', 24);
				animation.play(letter);
			case "%":
				animation.addByPrefix(letter, '%', 24);
				animation.play(letter);
			case "&":
				animation.addByPrefix(letter, '&', 24);
				animation.play(letter);
			case "(":
				animation.addByPrefix(letter, '(', 24);
				animation.play(letter);
			case ")":
				animation.addByPrefix(letter, ')', 24);
				animation.play(letter);
			case "+":
				animation.addByPrefix(letter, '+', 24);
				animation.play(letter);
			case "-":
				animation.addByPrefix(letter, '-', 24);
				animation.play(letter);
			case '"':
				animation.addByPrefix(letter, '"', 24);
				animation.play(letter);
				y -= 0;
			case '@':
				animation.addByPrefix(letter, '@', 24);
				animation.play(letter);
			case "^":
				animation.addByPrefix(letter, '^', 24);
				animation.play(letter);
				y -= 0;
			case ' ':
				animation.addByPrefix(letter, 'space', 24);
				animation.play(letter);
		}

		updateHitbox();
	}
}

/*
For the width technology:
Lets say you have the text "Hello There", where every character, including the space, is 50 pixels wide. This means the text will be 550 pixels wide.
But you set the width to be between 250 and 550, exclusive. (e.g. width = 300)
For the text to fit inside a 300 wide space, this means that it realises that the word "Hello" is less than 300, but the text "Hello There" is over 300.
So, it types the "Hello" and, instead of placing a space, it places a new line. What this means is all of "Hello" is lifted Y pixels up, where Y is the height of the characters.
*/
