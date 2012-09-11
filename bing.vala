
class BingSource: Object, WallpaperSource {

	public string get_id() { return "bing"; }
	public string get_name() { return "Bing's wallpaper feed"; }

	public async Wallpaper[] list_wallpapers() throws Error {
		File feed = File.new_for_uri("http://themeserver.microsoft.com/default.aspx?p=Bing&c=Desktop&m=en-US");
		uint8[] contents;
		if(!yield feed.load_contents_async(null, out contents, null)) {
			throw new IOError.FAILED("loading bing stream failed");
		}

		Wallpaper[] ret = {};
		// ugly libxml2 part ahead
		Xml.Doc* doc = Xml.Parser.read_doc((string) contents);
		Xml.XPath.Object* obj = null;
		if(doc == null)
			throw new IOError.FAILED("unable to parse XML document");
		try {
			Xml.XPath.Context ctx = new Xml.XPath.Context(doc);
			if(ctx == null) // ??? from example
				throw new IOError.FAILED("unable to create XPath context");
			obj = ctx.eval_expression("//item");
			if(obj==null || obj->nodesetval == null)
				throw new IOError.FAILED("no items in wallpaper list");
			ret = new Wallpaper[obj->nodesetval->length()];
			for(int i = 0; i < ret.length; ++i) {
				var item_node = obj->nodesetval->item(i);

				// extract link
				ctx.node = item_node;
				Xml.XPath.Object* obj2 = ctx.eval("string(link/@ref)");
				if(obj2 == null || obj2->stringval == null)
					throw new IOError.FAILED("no URI found");
				var uri = (string) obj2->stringval;
				File file = File.new_for_uri(uri);
				delete obj2;

				//extract date
				DateTime? datetime = null;
				ctx.node = item_node;
				obj2 = ctx.eval("string(pubDate)");
				if(obj2 == null || obj2->stringval == null)
					throw new IOError.FAILED("no date found");
				var time = Time();
				// TODO: will this break in other locales?
				unowned string? conversion_end = time.strptime(obj2->stringval, "%m/%d/%Y %r");
				if(conversion_end != null && conversion_end.length == 0) {
					// strptime was successful
					datetime = new DateTime.from_unix_utc(time.mktime());
				}
				delete obj2;

				ret[i] = new FileWallpaper(file, null, null, datetime);
			}
		} finally {
			delete obj;
			delete doc;
		}

		return ret;
	}
}
