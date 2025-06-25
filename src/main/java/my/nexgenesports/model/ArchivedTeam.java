package my.nexgenesports.model;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Snapshot of a team when disbanded.
 */
public class ArchivedTeam extends Team {
    private LocalDateTime archivedAt;

    public ArchivedTeam() {}

    public LocalDateTime getArchivedAt() {
        return archivedAt;
    }
    public void setArchivedAt(LocalDateTime archivedAt) {
        this.archivedAt = archivedAt;
    }

    @Override
    public String toString() {
        return super.toString() + " Archived at " + archivedAt;
    }

    @Override
    public boolean equals(Object o) {
        return super.equals(o);
    }
    @Override
    public int hashCode() {
        return super.hashCode();
    }
}
