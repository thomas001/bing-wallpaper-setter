
public class FileWallpaper: Object, Wallpaper {
	File file;
	string id;
	string name;
	DateTime? datetime;

	public FileWallpaper(File file, string? name = null, string? id = null, DateTime? datetime = null) {
		this.file = file;
		id = id!=null ? id : file.get_basename();
		if(name == null) {
			string basename = file.get_basename();
			int dot_pos = basename.last_index_of_char('.');
			if(dot_pos >= 0 && dot_pos < basename.length)
				this.name = basename.substring(0,dot_pos);
			else
				this.name = basename;
		} else {
			this.name = name;
		}
		this.datetime = datetime;
	}

	public async InputStream read(Cancellable? cancellable = null) throws Error {
		return yield get_file().read_async(Priority.DEFAULT, cancellable);
	}

	public string get_id() { return id; }
	public string get_name() { return name; }
	public File get_file() { return file; }
	public DateTime? get_date() { return datetime; }
}

