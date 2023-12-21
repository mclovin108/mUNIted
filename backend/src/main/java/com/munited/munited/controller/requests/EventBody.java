package com.munited.munited.controller.requests;

import com.munited.munited.model.User;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.security.Timestamp;
import java.sql.Date;
import java.time.LocalDateTime;
import java.util.List;

/**
 * EventBody repräsentiert den Request-Body bei der Erstellung eines Events.
 *
 * @author Nico Harbig
 */
@Getter
@Setter
@NoArgsConstructor
public class EventBody {
    private String title;
    private String icon;
    private LocalDateTime start;
    private String description;
    private int maxVisitors;
    private double costs;
    private List<String> labels;
    private Long creatorId;
    public EventBody(String title, String icon, LocalDateTime start, String description, int maxVisitors, int costs, List<String> labels, Long creatorId) {
        this.title = title;
        this.icon = icon;
        this.start = start;
        this.description = description;
        this.maxVisitors = maxVisitors;
        this.costs = costs;
        this.labels = labels;
        this.creatorId = creatorId;
    }

    public String getTitle() {
        return title;
    }

    public String getIcon() {
        return icon;
    }

    public LocalDateTime getStart() {
        return start;
    }

    public String getDescription() {
        return description;
    }

    public int getMaxVisitors() {
        return maxVisitors;
    }

    public double getCosts() {
        return costs;
    }

    public List<String> getLabels() {
        return labels;
    }

    public Long getCreatorId() {
        return creatorId;
    }

    @Override
    public String toString() {
        return "EventBody{" +
                "title='" + title + '\'' +
                ", icon='" + icon + '\'' +
                ", start=" + start +
                ", description='" + description + '\'' +
                ", maxVisitors=" + maxVisitors +
                ", costs=" + costs +
                ", labels=" + labels +
                ", creatorId=" + creatorId +
                '}';
    }
}
