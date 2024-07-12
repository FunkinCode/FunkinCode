package engine.discord;

class User {
    public var ID:String;
    public var _user:String;
    public var username:String;
    public var displayName:String;
    public var avatarURL:String;

    public function new(ID, username, ?url) {
        this.ID = ID;
        this.username = username;
    }
}