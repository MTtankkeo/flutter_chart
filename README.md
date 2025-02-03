# Introduction
This package provides widgets that can draw simple graphs to complex chart graphs, offering various customization options such as visibility, color, line width, line color, text color, and more.

> See Also, If you want the change-log by version for this package. refer to [Change Log](CHANGELOG.md) for details.

| Chart Type | Description | 🎞️ Animation | ✋ Interaction |
| ---------- | ----------- | ------------ | ----------- |
| 🟢 ColumnChart | Current supported. | 🟡 | 🟡 |
| 🔴 LineChart   | Not support yet.   | 🟡 | 🟡 |
| 🔴 PieChart    | Not support yet.   | 🟡 | 🟡 |

```
- 🟢 is current supported.
- 🟡 is planning to develop and apply.
- 🔴 is not supported or not yet supported.
```

# Preview
![column-chart](https://github.com/user-attachments/assets/a81e24cc-ec07-472f-a284-54f41ee21236)

# Usage
The following explains the basic usage of this package.

## When using a column chart.
```dart
ColumnChart(
    markType: ChartMarkType.percent,
    maxValue: 100,
    datas: [
        ChartLabeledData(label: "A", value: 90, color: Colors.deepOrange),
        ChartLabeledData(label: "B", value: 70, color: Colors.orange),
        ChartLabeledData(label: "C", value: 30, color: Colors.red),
        ChartLabeledData(label: "D", value: 70, color: Colors.blue),
    ],
)
```