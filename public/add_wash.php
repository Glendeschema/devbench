<?php
session_start();
require_once __DIR__ . '/../src/app.php';
if (!isset($_SESSION['username'])) {
    header("Location: login.php");
    exit;
}
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $type = trim($_POST['type']);
    addWash($_SESSION['username'], $type);
    header("Location: dashboard.php");
    exit;
}
include __DIR__ . '/../templates/header.php';
?>
<h2>Add Wash</h2>
<form method="POST">
    <label>Wash Type: <input type="text" name="type" required></label><br>
    <button type="submit">Add</button>
</form>
<p><a href="dashboard.php">Back</a></p>
<?php include __DIR__ . '/../templates/footer.php'; ?>
