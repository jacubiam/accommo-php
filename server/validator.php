<?php
function validator(array $data, string $context)
{
    $result = array("status" => true, "message" => "none");
    $model_keys = [];

    foreach ($data as $key => $value) {
        if (empty($value)) {
            $result['status'] = false;
            $result['message'] = "Empty or field with zero found ($key)";
            return $result;
        }
    }

    if ($context === "create") {
        if (count($data) !== 4) {
            $result['status'] = false;
            $result['message'] = "Unexpected amount of fields, sent " . count($data) . ", expected (4).";
            return $result;
        }

        //Match excpected keys to submitted data
        $model_keys = ["name", "username", "email", "password"];  
    }

    $data_keys = array_keys($data);
    $diff_keys = array_diff($data_keys, $model_keys);

    if (count($diff_keys) !== 0) {
        $result['status'] = false;
        $result['message'] = "Unexpected field: " . reset($diff_keys);
        return $result;
    }

    foreach ($data as $key => $value) {
        if ($key === "name") {
            if (!preg_match("/^([a-zA-Z]'?\.?\s?)+$/", $value)) {
                $result['status'] = false;
                $result['message'] = "$key only allows alphabetical chars";
                return $result;
            }
        }

        if ($key === "username") {
            if (!preg_match("/^([a-zA-Z]\d*)+$/", $value)) {
                $result['status'] = false;
                $result['message'] = "$key has a set of invalid characters or a combination of them";
                return $result;
            }
        }

        if ($key === "email") {
            if (!preg_match("/^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$/i", $value)) {
                $result['status'] = false;
                $result['message'] = "$key doesn't seem as a valid email";
                return $result;
            }
        }
        
        if ($key === "password") {
            if (!preg_match("/^[!-~ñÑ]+$/", $value)) {
                $result['status'] = false;
                $result['message'] = "$key has a set of invalid characters or a combination of them";
                return $result;
            }
        }
    }

    return $result;
}