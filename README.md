# Introduction
This package provides widgets that can draw simple graphs to complex chart graphs, offering various customization options such as visibility, color, line width, line color, text color, and more.

> See Also, If you want the change-log by version for this package. refer to [Change Log](CHANGELOG.md) for details.

| Chart Type | Description | 🎞️ Animation | ✋ Interaction |
| ---------- | ----------- | ------------ | ----------- |
| 🟢 ColumnChart | Current supported. | 🟢 | 🟢 |
| 🔴 LineChart   | Not support yet.   | 🟡 | 🟡 |
| 🔴 PieChart    | Not support yet.   | 🟡 | 🟡 |

```
- 🟢 is current supported.
- 🟡 is planning to develop and apply.
- 🔴 is not supported or not yet supported.
```

# Preview
![column-chart](https://github.com/user-attachments/assets/8fe9254b-d981-442c-9563-35505aac4472)

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

### The Properties of ColumnChart
| Name | Description | Type |
| ---- | ----------- | ---- |
| datas | The values that defines current the datas of column chart. | List<ChartLabeledData> |
| controller | The instance that defines the current controller of the chart. | ChartController? |
| animation | The instance that defines current animation setting values of the chart. | ChartAnimation? |
| behavior | The instance that defines the current controller of the chart. | ChartBehavior? |
| backgroundColor | The background color excluding the separated text area and the bottom labels area. | Color? |
| barRatio | The ratio that is rate of width at which the bar is rendered in the bar area. | double |
| maxValue | The value that defines the maximum value in this chart. | double? |
| markType | The value that defines type of how to display values in a chart. | ChartMarkType |
| theme | The value that defines the theme in this chart. | ChartTheme? |
| onTap | The callback that is called when each bar in the column chart is single tapped. | ChartInteractionCallback? |
| onDoubleTap | The callback that is called when each bar in the column chart is double tapped. | ChartInteractionCallback? |
| onLongPress | The callback that is called when each bar in the column chart is long pressed. | ChartInteractionCallback? |
| onHoverStart | The callback that is called when each bar in the column chart is hover started. | ChartInteractionCallback? |
| onHoverEnd | The callback that is called when each bar in the column chart is hover ended. | ChartInteractionCallback? |
| separatedLineCount | Not commented yet. | int |
| separatedLineColor | Not commented yet. | Color? |
| separatedLineWidth | Not commented yet. | double |
| separatedTextStyle | Not commented yet. | TextStyle? |
| separatedTextMargin | Not commented yet. | double |
| separatedTextAlignment | Not commented yet. | ChartSeparatedTextAlignment |
| separatedTextDirection | Not commented yet. | ChartSeparatedTextDirection |
| separatedBorderColor | Not commented yet. | Color? |
| separatedBorderWidth | Not commented yet. | double? |
| separatedLineCap | Not commented yet. | StrokeCap |
| labelTextMargin | Not commented yet. | double |
| labelTextStyle | Not commented yet. | TextStyle? |
| barInnerTextMargin | Not commented yet. | double |
| barOuterTextMargin | Not commented yet. | double |
| barTextInnerStyle | Not commented yet. | ChartTextStyleBuilder? |
| barTextOuterStyle | Not commented yet. | ChartTextStyleBuilder? |
| barTextAlignment | Not commented yet. | ChartBarTextAlignment |
| barBorderRadius | Not commented yet. | BorderRadius |
| barColor | Not commented yet. | Color? |
| isVisibleSeparatedText | Not commented yet. | bool |
| isVisibleBarText | Not commented yet. | bool |
| isVisibleLabel | Not commented yet. | bool |