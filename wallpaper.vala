
public interface Wallpaper: Object {
	public abstract string get_id();
	public abstract string get_name();
	public DateTime? get_date() { return null; }

	public abstract async InputStream read(Cancellable? cancellable = null) throws Error;

}

public interface WallpaperSource: Object {
	public abstract string get_id();
	public abstract string get_name();

	public abstract async Wallpaper[] list_wallpapers() throws Error;
}
