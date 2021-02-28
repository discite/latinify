pub fn upscale_string(input: String) -> String {
    return input.to_uppercase()
        .replace("J", "I")
        .replace("U", "V")
        .replace("W", "V");
}