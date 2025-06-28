package my.nexgenesports.service.programTournament;

import okhttp3.*;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.Map;
import my.nexgenesports.model.ChallongeTournament;
import my.nexgenesports.model.ProgramTournament;

public class ChallongeClient {
    private static final String API_KEY    = "WKSIQHV1XiHk7WTUeOf5wHpbBv1qv5yAsm7qLitp";
    private static final String BASE_URL   = "https://api.challonge.com/v1";
    private final OkHttpClient http        = new OkHttpClient();
    private final ObjectMapper  mapper     = new ObjectMapper();

    public ChallongeTournament createTournament(ProgramTournament pt) throws IOException {
        HttpUrl url = HttpUrl.parse(BASE_URL + "/tournaments.json").newBuilder()
            .addQueryParameter("api_key", API_KEY)
            .addQueryParameter("tournament[name]", pt.getProgramName())
            .addQueryParameter("tournament[tournament_type]", pt.getProgramType().equals("TOURNAMENT") ? "single elimination" : "round robin")
            .addQueryParameter("tournament[description]", pt.getDescription())
            .build();

        Request req = new Request.Builder().url(url).post(RequestBody.create(new byte[0])).build();
        try (Response resp = http.newCall(req).execute()) {
            if (!resp.isSuccessful()) throw new IOException("Challonge create failed: " + resp);
            Map<?,?> wrapper = mapper.readValue(resp.body().string(), Map.class);
            Map<?,?> tdata   = (Map<?,?>)wrapper.get("tournament");
            ChallongeTournament ct = new ChallongeTournament();
            ct.setProgId(pt.getProgId());
            ct.setChallongeTournamentId(String.valueOf(tdata.get("id")));
            ct.setChallongeUrl((String)tdata.get("full_challonge_url"));
            return ct;
        }
    }

    public ChallongeTournament syncTournament(ChallongeTournament existing) throws IOException {
        String path = String.format("/tournaments/%s.json", existing.getChallongeTournamentId());
        HttpUrl url = HttpUrl.parse(BASE_URL + path).newBuilder()
            .addQueryParameter("api_key", API_KEY)
            .build();

        Request req = new Request.Builder().url(url).get().build();
        try (Response resp = http.newCall(req).execute()) {
            if (!resp.isSuccessful()) throw new IOException("Challonge sync failed: " + resp);
            Map<?,?> wrapper = mapper.readValue(resp.body().string(), Map.class);
            Map<?,?> tdata   = (Map<?,?>)wrapper.get("tournament");
            existing.setChallongeState((String)tdata.get("state"));
            existing.setChallongeLastSyncAt(java.time.LocalDateTime.now());
            return existing;
        }
    }
}
