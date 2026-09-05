package com.mustinverter.monitor.ui.screens

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.PaddingValues
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material.icons.filled.Delete
import androidx.compose.material.icons.filled.Settings
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.CardDefaults
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.material3.IconButton
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TopAppBar
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.navigation.NavHostController
import com.mustinverter.monitor.data.model.Inverter

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun DevicesListScreen(navController: NavHostController) {
    val devices = remember { mutableStateListOf<Inverter>() }
    var showAddDialog by remember { mutableStateOf(false) }
    var ipInput by remember { mutableStateOf("") }
    var nameInput by remember { mutableStateOf("") }

    Scaffold(
        topBar = {
            TopAppBar(
                title = { Text("MUST Inverter Monitor") },
                actions = {
                    IconButton(onClick = { navController.navigate("settings") }) {
                        Icon(Icons.Default.Settings, contentDescription = "Settings")
                    }
                }
            )
        },
        floatingActionButton = {
            FloatingActionButton(
                onClick = { showAddDialog = true }
            ) {
                Icon(Icons.Default.Add, contentDescription = "Add Device")
            }
        }
    ) { paddingValues ->
        if (devices.isEmpty()) {
            Box(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentAlignment = Alignment.Center
            ) {
                Column(
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Text("No devices added")
                    Button(
                        onClick = { showAddDialog = true },
                        modifier = Modifier.padding(top = 16.dp)
                    ) {
                        Text("Add Device")
                    }
                }
            }
        } else {
            LazyColumn(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(paddingValues),
                contentPadding = PaddingValues(16.dp),
                verticalArrangement = Arrangement.spacedBy(8.dp)
            ) {
                items(devices) { device ->
                    DeviceCard(
                        device = device,
                        onDeviceClick = {
                            navController.navigate("device/${device.id}")
                        },
                        onDelete = {
                            devices.remove(device)
                        }
                    )
                }
            }
        }
    }

    if (showAddDialog) {
        AddDeviceDialog(
            onDismiss = { showAddDialog = false },
            onAdd = { ip, name ->
                val newDevice = Inverter(
                    id = System.currentTimeMillis().toString(),
                    name = name.ifEmpty { "Device $ip" },
                    ipAddress = ip,
                    voltage = 0.0,
                    current = 0.0,
                    power = 0.0,
                    temperature = 0.0
                )
                devices.add(newDevice)
                ipInput = ""
                nameInput = ""
                showAddDialog = false
            },
            ipInput = ipInput,
            onIpChange = { ipInput = it },
            nameInput = nameInput,
            onNameChange = { nameInput = it }
        )
    }
}

@Composable
fun DeviceCard(
    device: Inverter,
    onDeviceClick: () -> Unit,
    onDelete: () -> Unit
) {
    Card(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 4.dp),
        elevation = CardDefaults.cardElevation(defaultElevation = 2.dp)
    ) {
        Row(
            modifier = Modifier
                .fillMaxWidth()
                .padding(16.dp),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(
                modifier = Modifier
                    .weight(1f)
                    .padding(end = 8.dp)
            ) {
                Text(device.name, style = androidx.compose.material3.MaterialTheme.typography.headlineSmall)
                Text(device.ipAddress, style = androidx.compose.material3.MaterialTheme.typography.bodySmall)
            }
            Row {
                Button(onClick = onDeviceClick) {
                    Text("Open")
                }
                IconButton(onClick = onDelete) {
                    Icon(Icons.Default.Delete, contentDescription = "Delete")
                }
            }
        }
    }
}

@Composable
fun AddDeviceDialog(
    onDismiss: () -> Unit,
    onAdd: (ip: String, name: String) -> Unit,
    ipInput: String,
    onIpChange: (String) -> Unit,
    nameInput: String,
    onNameChange: (String) -> Unit
) {
    androidx.compose.material3.AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text("Add Device") },
        text = {
            Column(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                OutlinedTextField(
                    value = nameInput,
                    onValueChange = onNameChange,
                    label = { Text("Device Name") },
                    modifier = Modifier.fillMaxWidth()
                )
                OutlinedTextField(
                    value = ipInput,
                    onValueChange = onIpChange,
                    label = { Text("IP Address") },
                    placeholder = { Text("192.168.1.100") },
                    modifier = Modifier.fillMaxWidth()
                )
            }
        },
        confirmButton = {
            Button(
                onClick = {
                    if (ipInput.isNotEmpty()) {
                        onAdd(ipInput, nameInput)
                    }
                }
            ) {
                Text("Add")
            }
        },
        dismissButton = {
            Button(onClick = onDismiss) {
                Text("Cancel")
            }
        }
    )
}
