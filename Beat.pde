public class Beat {
    int timestamp;
    int type;
    boolean hold;
    int duration;
    int ID;

    public Beat(int timestamp, int type, boolean hold, int duration, int ID) {
        this.timestamp = timestamp;
        this.type = type;
        this.hold = hold;
        this.duration = duration;
        this.ID = ID;
    }
}
