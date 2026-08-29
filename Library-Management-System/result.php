<?php

$servername = "localhost";
$username = "root";
$password = "";
$dbname = "iudbs";

/* =========================================================
   CONNECT DATABASE
   ========================================================= */

$conn = new mysqli(
    $servername,
    $username,
    $password,
    $dbname
);

if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

$conn->set_charset("utf8mb4");


/* =========================================================
   GET FORM DATA
   ========================================================= */

$table = isset($_POST['table']) ? $_POST['table'] : '';

$function = isset($_POST['function']) ? $_POST['function'] : '';

$selected_columns = isset($_POST['columns'])
    ? $_POST['columns']
    : [];


/* =========================================================
   ALLOWED TABLES
   ========================================================= */

$allowed_tables = [
    "category",
    "author",
    "storage",
    "book",
    "enrol"
];

if (!in_array($table, $allowed_tables)) {
    die("Invalid table.");
}


/* =========================================================
   ALLOWED COLUMNS
   ========================================================= */

$allowed_columns = [

    "category" => [
        "category_id",
        "category",
        "sub_category",
        "book_country",
        "target_audience",
        "recommended_age",
        "description",
        "average_rating",
        "keyword",
        "popular_book"
    ],

    "author" => [
        "author_id",
        "name",
        "pen_name",
        "date_of_birth",
        "gender",
        "field",
        "address",
        "email",
        "nationality",
        "active_year"
    ],

    "storage" => [
        "storage_id",
        "block",
        "capacity",
        "current_quantity",
        "condition",
        "last_checked_day",
        "manager_name",
        "category",
        "shelf",
        "floor"
    ],

    "book" => [
        "book_id",
        "title",
        "edition",
        "publisher",
        "year",
        "author",
        "category_id",
        "language",
        "number_page",
        "storage_id"
    ],

    "enrol" => [
        "book_id",
        "title",
        "edition",
        "publisher",
        "year",
        "language",
        "number_page",
        "author_name",
        "pen_name",
        "date_of_birth",
        "gender",
        "field",
        "sub_category",
        "category",
        "book_country",
        "target_audience",
        "block",
        "manager_name"
    ]
];


/* =========================================================
   PRIMARY KEY CỦA TỪNG BẢNG
   (dùng cho Update / Delete — KHÔNG lấy theo checkbox nữa,
   vì cột đầu tiên được tick có thể không phải là ID,
   dẫn đến update/delete nhầm nhiều dòng cùng lúc)
   ========================================================= */

$primary_keys = [
    "category" => "category_id",
    "author"   => "author_id",
    "storage"  => "storage_id",
    "book"     => "book_id"
];


/* =========================================================
   VALIDATE COLUMNS
   ========================================================= */

if ($table != "enrol") {

    $selected_columns = array_values(
        array_intersect(
            $selected_columns,
            $allowed_columns[$table]
        )
    );

    if (empty($selected_columns)) {
        $selected_columns = $allowed_columns[$table];
    }
}


/* =========================================================
   CSS
   ========================================================= */

echo '

<style>

body {
    font-family: Arial, sans-serif;
    background-color: #f5f6fa;
    margin: 0;
    padding: 30px;
}

.result-container {
    max-width: 1400px;
    margin: auto;
    background-color: white;
    padding: 30px;
    border-radius: 15px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.10);
}

h2 {
    text-align: center;
    color: #34495e;
    margin-bottom: 25px;
}

.message {
    text-align: center;
    padding: 15px;
    margin: 20px 0;
    font-size: 18px;
    font-weight: bold;
}

.success {
    color: #27ae60;
}

.error {
    color: #c0392b;
}

table {
    width: 100%;
    border-collapse: collapse;
    margin: 20px 0;
    font-family: Arial, sans-serif;
}

th {
    background-color: #34495e;
    color: white;
    padding: 12px;
    border: 1px solid #ddd;
    text-align: left;
}

td {
    padding: 10px;
    border: 1px solid #ddd;
    color: #333;
}

tr:nth-child(even) {
    background-color: #f2f2f2;
}

tr:hover {
    background-color: #eaf2f8;
}

.back-button {
    display: inline-block;
    margin-top: 20px;
    padding: 12px 20px;
    background-color: #3498db;
    color: white;
    text-decoration: none;
    border-radius: 8px;
}

.back-button:hover {
    background-color: #2980b9;
}

</style>

';


echo '<div class="result-container">';


/* =========================================================
   DISPLAY RESULT
   ========================================================= */

function displayResults($result, $selected_columns)
{

    if (!$result) {

        echo '
        <div class="message error">
            Database error.
        </div>
        ';

        return;
    }


    if ($result->num_rows == 0) {

        echo '
        <div class="message">
            No data found.
        </div>
        ';

        return;
    }


    echo "<table>";

    echo "<tr>";

    foreach ($selected_columns as $column) {

        echo "<th>" .
            htmlspecialchars($column) .
            "</th>";
    }

    echo "</tr>";


    while ($row = $result->fetch_assoc()) {

        echo "<tr>";

        foreach ($selected_columns as $column) {

            $value = isset($row[$column])
                ? $row[$column]
                : "";

            if ($value === null || $value === "") {
                $value = "NULL";
            }

            echo "<td>" .
                htmlspecialchars($value) .
                "</td>";
        }

        echo "</tr>";
    }

    echo "</table>";
}


/* =========================================================
   SHOW NORMAL TABLE
   ========================================================= */

function showTable($conn, $table, $selected_columns)
{

    $columns = [];

    foreach ($selected_columns as $column) {

        $columns[] = "`" . $column . "`";
    }

    $columns_list = implode(", ", $columns);


    $sql = "
        SELECT $columns_list
        FROM `$table`
    ";


    $result = $conn->query($sql);


    if (!$result) {

        echo '
        <div class="message error">

            Error:
            ' .
            htmlspecialchars($conn->error) .
            '

        </div>
        ';

        return;
    }


    echo "<h2>" .
        htmlspecialchars(ucfirst($table)) .
        "</h2>";


    displayResults(
        $result,
        $selected_columns
    );
}


/* =========================================================
   MULTIPLE TABLE
   ========================================================= */

function showMultiple($conn, $selected_columns)
{

    /*
       Multiple combines:

       BOOK
       AUTHOR
       CATEGORY
       STORAGE
    */


    $column_map = [

        "book_id" =>
            "b.book_id",

        "title" =>
            "b.title",

        "edition" =>
            "b.edition",

        "publisher" =>
            "b.publisher",

        "year" =>
            "b.year",

        "language" =>
            "b.language",

        "number_page" =>
            "b.number_page",

        "author_name" =>
            "b.author",

        "pen_name" =>
            "a.pen_name",

        "date_of_birth" =>
            "a.date_of_birth",

        "gender" =>
            "a.gender",

        "field" =>
            "a.field",

        "sub_category" =>
            "c.sub_category",

        "category" =>
            "c.category",

        "book_country" =>
            "c.book_country",

        "target_audience" =>
            "c.target_audience",

        "block" =>
            "s.block",

        "manager_name" =>
            "s.manager_name"
    ];


    $select = [];


    foreach ($selected_columns as $column) {

        if (isset($column_map[$column])) {

            $select[] =
                $column_map[$column] .
                " AS `" .
                $column .
                "`";
        }
    }


    if (empty($select)) {

        echo '
        <div class="message error">
            No valid columns selected.
        </div>
        ';

        return;
    }


    /*
       IMPORTANT:

       Your book table already contains
       the author name in b.author.

       Therefore we join author
       using author name.

       We do NOT use book_author here.
    */


    $sql = "

        SELECT

            " .
            implode(", ", $select) .
            "

        FROM book b

        LEFT JOIN author a
            ON b.author = a.name

        LEFT JOIN category c
            ON b.category_id = c.category_id

        LEFT JOIN storage s
            ON b.storage_id = s.storage_id

    ";


    $result = $conn->query($sql);


    if (!$result) {

        echo '
        <div class="message error">

            <strong>
                Multiple table error:
            </strong>

            <br><br>

            ' .
            htmlspecialchars($conn->error) .
            '

        </div>
        ';

        return;
    }


    echo "<h2>Multiple Table</h2>";


    displayResults(
        $result,
        $selected_columns
    );
}


/* =========================================================
   SHOW TABLE
   ========================================================= */

if ($function == "show_table") {

    if ($table == "enrol") {

        showMultiple(
            $conn,
            $selected_columns
        );

    } else {

        showTable(
            $conn,
            $table,
            $selected_columns
        );
    }
}


/* =========================================================
   SEARCH
   ========================================================= */

elseif ($function == "search") {

    if ($table == "enrol") {

        echo '
        <div class="message error">

            Search is not available
            for Multiple table.

            <br><br>

            Please select a normal table.

        </div>
        ';

    } else {

        $conditions = [];

        $values = [];

        $types = "";


        foreach ($selected_columns as $column) {

            if (
                isset($_POST[$column]) &&
                $_POST[$column] !== ""
            ) {

                $conditions[] =
                    "`$column` LIKE ?";

                $values[] =
                    "%" .
                    $_POST[$column] .
                    "%";

                $types .= "s";
            }
        }


        if (empty($conditions)) {

            echo '
            <div class="message error">

                No search criteria provided.

            </div>
            ';

        } else {

            $columns_list =
                implode(
                    ", ",
                    array_map(
                        function ($column) {

                            return "`" .
                                $column .
                                "`";
                        },
                        $selected_columns
                    )
                );


            $sql = "

                SELECT
                    $columns_list

                FROM
                    `$table`

                WHERE
                    " .
                implode(
                    " AND ",
                    $conditions
                );

            $stmt =
                $conn->prepare($sql);


            if (!$stmt) {

                echo '
                <div class="message error">

                    Error:
                    ' .
                    htmlspecialchars(
                        $conn->error
                    ) .
                    '

                </div>
                ';

            } else {

                $stmt->bind_param(
                    $types,
                    ...$values
                );

                $stmt->execute();

                $result =
                    $stmt->get_result();


                echo "<h2>Search Result</h2>";


                displayResults(
                    $result,
                    $selected_columns
                );


                $stmt->close();
            }
        }
    }
}


/* =========================================================
   INSERT
   ========================================================= */

elseif ($function == "insert") {

    if ($table == "enrol") {

        echo '
        <div class="message error">

            Multiple table cannot be inserted directly.

            <br><br>

            Please choose Category, Author,
            Storage or Book.

        </div>
        ';

    } else {

        $columns = [];

        $values = [];

        $types = "";


        foreach ($selected_columns as $column) {

            if (
                isset($_POST[$column]) &&
                $_POST[$column] !== ""
            ) {

                $columns[] =
                    "`$column`";

                $values[] =
                    $_POST[$column];

                $types .= "s";
            }
        }


        if (empty($columns)) {

            echo '
            <div class="message error">

                No values to insert.

            </div>
            ';

        } else {

            $placeholders =
                implode(
                    ", ",
                    array_fill(
                        0,
                        count($values),
                        "?"
                    )
                );


            $sql = "

                INSERT INTO `$table`

                (" .
                implode(
                    ", ",
                    $columns
                ) .
                ")

                VALUES

                (" .
                $placeholders .
                ")

            ";


            $stmt =
                $conn->prepare($sql);


            if (!$stmt) {

                echo '
                <div class="message error">

                    Error:
                    ' .
                    htmlspecialchars(
                        $conn->error
                    ) .
                    '

                </div>
                ';

            } else {

                $stmt->bind_param(
                    $types,
                    ...$values
                );


                if ($stmt->execute()) {

                    echo '
                    <div class="message success">

                        Record inserted successfully.

                    </div>
                    ';


                    showTable(
                        $conn,
                        $table,
                        $selected_columns
                    );

                } else {

                    echo '
                    <div class="message error">

                        Error inserting record:

                        <br><br>

                        ' .
                        htmlspecialchars(
                            $stmt->error
                        ) .
                        '

                    </div>
                    ';
                }


                $stmt->close();
            }
        }
    }
}


/* =========================================================
   UPDATE
   ========================================================= */

elseif ($function == "update") {

    if ($table == "enrol") {

        echo '
        <div class="message error">

            Multiple table cannot be updated directly.

            <br><br>

            Please update the original table.

        </div>
        ';

    } else {

        if (empty($selected_columns)) {

            echo '
            <div class="message error">

                No column selected.

            </div>
            ';

        } else {

            $id_column =
                $primary_keys[$table];


            $id_value =
                isset($_POST[$id_column])
                ? $_POST[$id_column]
                : "";


            if ($id_value === "") {

                echo '
                <div class="message error">

                    ID value (' .
                    htmlspecialchars($id_column) .
                    ') is required.

                </div>
                ';

            } else {

                $update_parts = [];

                $values = [];

                $types = "";


                foreach (
                    $selected_columns
                    as $column
                ) {

                    if ($column == $id_column) {
                        continue;
                    }


                    if (
                        isset($_POST[$column]) &&
                        $_POST[$column] !== ""
                    ) {

                        $update_parts[] =
                            "`$column` = ?";

                        $values[] =
                            $_POST[$column];

                        $types .= "s";
                    }
                }


                if (empty($update_parts)) {

                    echo '
                    <div class="message error">

                        No values to update.

                    </div>
                    ';

                } else {

                    $sql = "

                        UPDATE `$table`

                        SET
                            " .
                        implode(
                            ", ",
                            $update_parts
                        ) .

                        "

                        WHERE
                            `$id_column` = ?

                    ";


                    $values[] =
                        $id_value;

                    $types .= "s";


                    $stmt =
                        $conn->prepare($sql);


                    if (!$stmt) {

                        echo '
                        <div class="message error">

                            Error:
                            ' .
                            htmlspecialchars(
                                $conn->error
                            ) .
                            '

                        </div>
                        ';

                    } else {

                        $stmt->bind_param(
                            $types,
                            ...$values
                        );


                        if ($stmt->execute()) {

                            echo '
                            <div class="message success">

                                Record updated successfully.

                            </div>
                            ';


                            showTable(
                                $conn,
                                $table,
                                $selected_columns
                            );

                        } else {

                            echo '
                            <div class="message error">

                                Error updating record:

                                <br><br>

                                ' .
                                htmlspecialchars(
                                    $stmt->error
                                ) .
                                '

                            </div>
                            ';
                        }


                        $stmt->close();
                    }
                }
            }
        }
    }
}


/* =========================================================
   DELETE
   ========================================================= */

elseif ($function == "delete") {

    if ($table == "enrol") {

        echo '
        <div class="message error">

            Multiple table cannot be deleted directly.

            <br><br>

            Please delete from the original table.

        </div>
        ';

    } else {

        if (empty($selected_columns)) {

            echo '
            <div class="message error">

                No column selected.

            </div>
            ';

        } else {

            $id_column =
                $primary_keys[$table];


            $id_value =
                isset($_POST[$id_column])
                ? $_POST[$id_column]
                : "";


            if ($id_value === "") {

                echo '
                <div class="message error">

                    ID value (' .
                    htmlspecialchars($id_column) .
                    ') is required.

                </div>
                ';

            } else {

                $sql = "

                    DELETE FROM `$table`

                    WHERE `$id_column` = ?

                ";


                $stmt =
                    $conn->prepare($sql);


                if (!$stmt) {

                    echo '
                    <div class="message error">

                        Error:
                        ' .
                        htmlspecialchars(
                            $conn->error
                        ) .
                        '

                    </div>
                    ';

                } else {

                    $stmt->bind_param(
                        "s",
                        $id_value
                    );


                    if ($stmt->execute()) {

                        echo '
                        <div class="message success">

                            Record deleted successfully.

                        </div>
                        ';


                        showTable(
                            $conn,
                            $table,
                            $selected_columns
                        );

                    } else {

                        echo '
                        <div class="message error">

                            Error deleting record:

                            <br><br>

                            ' .
                            htmlspecialchars(
                                $stmt->error
                            ) .
                            '

                        </div>
                        ';
                    }


                    $stmt->close();
                }
            }
        }
    }
}


/* =========================================================
   INVALID FUNCTION
   ========================================================= */

else {

    echo '
    <div class="message error">

        Please select an activity.

    </div>
    ';
}


/* =========================================================
   BACK BUTTON
   ========================================================= */

echo '

<a
    href="research.html"
    class="back-button"
>

    ← Back to Library Management System

</a>

';


echo '</div>';


/* =========================================================
   CLOSE CONNECTION
   ========================================================= */

$conn->close();

?>