package com.mustinverter.monitor.data.model

data class Inverter(
    val id: String,
    val name: String,
    val ipAddress: String,
    val voltage: Double,
    val current: Double,
    val power: Double,
    val temperature: Double
)
