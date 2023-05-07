public class Beat {
    int timestampGeneration;
    int timestampArrival;
    int type;
    boolean hold;
    int duration;
    int ID;

    public Beat(int timestampGeneration, int type, boolean hold, int duration, int ID) {
        this.timestampGeneration = timestampGeneration;
        this.timestampArrival = timestampGeneration;
        this.type = type;
        this.hold = hold;
        this.duration = duration;
        this.ID = ID;
    }
}
