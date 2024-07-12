package api.routes;

typedef User = {
    var ID: String;
    var Username: String;
    @:optional var Email: Null<String>;
    @:optional var DisplayUsername: Null<String>;
    @:optional var AvatarURL: Null<String>;
    @:optional var DiscordID: Null<String>;
    @:optional var GithubID: Null<String>;
    var Flags: Int;
    var CreatedAt: Date;
    var LastUpdated: Date;
    var Private: Bool;
}