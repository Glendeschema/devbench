<?php
session_start();
require_once __DIR__ . '/../src/app.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);
    if (registerUser($username, $password)) {
        $_SESSION['message'] = "Registration successful. Please login.";
        header("Location: login.php");
        exit;
    } else {
        $error = "Username already exists.";
    }
}
include __DIR__ . '/../templates/header.php';
?>
<h2>Register</h2>
<?php if (!empty($error)) echo "<p style='color:red;'>$error</p>"; ?>
<form method="POST">
    <label>Username: <input type="text" name="username" required></label><br>
    <label>Password: <input type="password" name="password" required></label><br>
    <button type="submit">Register</button>
</form>
<p><a href="login.php">Login</a></p>
<?php include __DIR__ . '/../templates/footer.php'; ?>
