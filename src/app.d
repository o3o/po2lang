import std.stdio;
import std.algorithm;
import std.regex;

void main(string[] args) {
   if (args.length > 1) {
      string  poFile = args[1];
      convert(poFile);
   } else {
      writeln("invalid filename");
      writeln("   po2lang x.po");
   }
}

void convert(string poFile) {
   enum state {
      waitID,
      waitStr
   }

   state st = state.waitID;
   auto file = File(poFile);
   foreach (line; file.byLine()) {
      switch (st) {
         case state.waitID:
            if (line.startsWith("msgid")) {
               auto idReg = regex(`^msgid\s*"([^"]+)"`);
               auto m = match(line, idReg);
               writef(`"%s"`, m.captures[1]);
               //write("1: ", m.captures[1]);
               st = state.waitStr;
            }
            break;
         case state.waitStr:
            if (line.startsWith("msgstr")) {
               auto idS = regex(`^msgstr\s*"([^"]+)"`);
               auto m = match(line, idS);
               writefln(`="%s"`, m.captures[1]);
               st = state.waitID;
            }
            break;
         default:
            assert(false);
      }
   }
}
