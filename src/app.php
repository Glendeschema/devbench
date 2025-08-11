<?php
define('DATA_FILE', __DIR__ . '/../data/db.json');

function loadData() {
    if (!file_exists(DATA_FILE)) {
        return ['users' => [], 'washes' => []];
    }
    return json_decode(file_get_contents(DATA_FILE), true);
}

function saveData($data) {
    file_put_contents(DATA_FILE, json_encode($data, JSON_PRETTY_PRINT));
}

function registerUser($username, $password) {
    $data = loadData();
    foreach ($data['users'] as $user) {
        if ($user['username'] === $username) {
            return false;
        }
    }
    $data['users'][] = [
        'username' => $username,
        'password' => password_hash($password, PASSWORD_DEFAULT)
    ];
    saveData($data);
    return true;
}

function loginUser($username, $password) {
    $data = loadData();
    foreach ($data['users'] as $user) {
        if ($user['username'] === $username && password_verify($password, $user['password'])) {
            return true;
        }
    }
    return false;
}

function addWash($username, $type) {
    $data = loadData();
    $data['washes'][] = [
        'username' => $username,
        'type' => $type,
        'date' => date('Y-m-d H:i:s')
    ];
    saveData($data);
}

function getUserWashes($username) {
    $data = loadData();
    return array_values(array_filter($data['washes'], fn($w) => $w['username'] === $username));
}
