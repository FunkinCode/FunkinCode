#if !flash
import animate.FlxAnimate;
import animate.FlxSymbol;

#if hxcodec
import hxcodec.flixel.FlxVideo;
#end
import utils.ScriptManager;
import utils.Script;
import forward.BGSprite;
import forward.MusicBeatState;
import forward.MusicBeatSubstate;

import shaderslmfao.BlendModeEffect;
import shaderslmfao.BuildingShaders;
import shaderslmfao.ColorSwap;
import shaderslmfao.OverlayShader;
import shaderslmfao.WiggleEffect;

import sprites.Alphabet;
import sprites.BackgroundDancer;
import sprites.BackgroundGirls;
import sprites.Boyfriend;
import sprites.Character;
import sprites.CutsceneCharacter;
import sprites.DialogueBox;
import sprites.HealthIcon;
import sprites.MenuCharacter;
import sprites.MainMenuItem;
import sprites.Note;
import sprites.NoteSplash;
import sprites.SwagCamera;
import sprites.TankCutscene;
import sprites.TankmenBG;

import states.AnimationDebug;
import states.ChartingState;
import states.CutsceneAnimTestState;
import states.DebugBoundingState;
import states.FreeplayState;
import states.GameOverState;
import states.GitarooPause;
import states.LatencyState;
import states.LoadingState;
import states.MainMenuState;
import states.OutdatedSubState;
import states.PlayState;
import states.StoryMenuState;
import states.VideoState;

import substates.GameOverSubstate;
import substates.PauseSubState;

#if switch
import switch.Snd;
import switch.SndTV;
#end
import translate.File;

import ui.AtlasMenuList;
import ui.AtlasText;
import ui.ColorsMenu;
import ui.ControlsMenu;
import ui.MenuList;
import ui.ModMenu;
import ui.NgPrompt;
import ui.OptionsState;
import ui.PreferencesMenu;
import ui.Prompt;
import ui.TextMenuList;

import utils.APIStuff;
import utils.Conductor;
import utils.Controls;
import utils.Controls.Control;
import utils.CoolUtil;
#if discord_rpc
import utils.Discord;
import utils.Discord.DiscordClient;

#end
import utils.Highscore;
import utils.InputFormatter;
import utils.Mods;
import utils.NGio;
import utils.Paths;
import utils.Song;
import utils.Song.Song;
import utils.Song.SwagSong;
import utils.PlayerSettings;
import utils.Section.Section;
import utils.Section.SwagSection;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BitmapData;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.ShaderFilter;


import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.ui.FlxInputText;
import flixel.addons.ui.FlxUI9SliceSprite;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUICheckBox;
import flixel.addons.ui.FlxUIDropDownMenu;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.addons.ui.FlxUITooltip.FlxUITooltipStyle;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.sound.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSpriteButton;
import flixel.util.FlxColor;
import haxe.Json;
import lime.utils.Assets;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.media.Sound;
import openfl.net.FileReference;
import openfl.utils.ByteArray;

using StringTools;

import flixel.FlxG;
import flixel.input.FlxInput;
import flixel.input.actions.FlxAction;
import flixel.input.actions.FlxActionInput;
import flixel.input.actions.FlxActionInputDigital;
import flixel.input.actions.FlxActionManager;
import flixel.input.actions.FlxActionSet;
import flixel.input.gamepad.FlxGamepadButton;
import flixel.input.gamepad.FlxGamepadInputID;
import flixel.input.keyboard.FlxKey;

import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
#end