require 'sinatra'
#require 'sinatra/reloader'
require 'set'

def load_words
  #Returns a list of valid words. Words are strings of lowercase letters
  #
  # Depending on the size of the word list, this function may take a while to finish

  puts("Loading word list from file...")
  word_list = []
  file = File.open("words.txt", "r")
  data = file.read
  word_list = data.split(' ')

  puts(word_list.length.to_s + " words loaded.")
  return word_list
end

def choose_word(word_list)
  # Returns a word from word_list at random

  random = rand(word_list.length)

  return word_list[random]
end

word_list = load_words

def is_word_guessed(secret_word, letters_guessed)
  boolean = false

  secret_set = secret_word.split('')
  
  secret_set_copy = secret_set.to_set

  if secret_set_copy.subset?(letters_guessed.to_set)
    boolean = true
  end

  return boolean
end

def get_guessed_word(secret_word, letters_guessed)
  secret = ''

  secret_word = secret_word.split('')

  secret_word.each do |char|
    if letters_guessed.include?(char)
      #Put the letter guessed of the word
      secret += char
      secret += ' '
    else
      #Put a '_' as a way to tell that those letters haven't been guessed
      secret += '_'
      secret += ' '
    end
  end

  return secret
end

def get_available_letters(letters_guessed)
  list_letters = []
  letters = ''

  for i in 97..122
    list_letters.push(i)
  end

  list_letters.each do |j|
    if letters_guessed.include?(j.chr) == false
      letters += j.chr
    end
  end

  return letters
end

=begin
def hangman(secret_word)
  puts("The word have #{secret_word.length} letters")

  letters_guessed = []

  boolean = false

  i = 8

  while boolean == false
    puts("You have #{i} guesses left.")

    available_letters = get_available_letters(letters_guessed)

    puts("Available letters: #{available_letters}")

    puts("Please guess a letter: ")
    letter = gets
    letter = letter.downcase.chop

    if letters_guessed.include?(letter)
      puts("Oops! You've already guessed that letter")
    else
      letters_guessed.push(letter)
    end

    secret = get_guessed_word(secret_word, letters_guessed)

    secret_word_copy = secret_word.split('')

    if secret_word_copy.include?(letter)
      puts("Good guess: #{secret}")
    else
      i -= 1
      puts("Oops! That letter is not in the word: #{secret}")
    end

    if i == 0
      puts("Sorry, you ran out of guesses")
      puts("The word was #{secret_word}")
      break
    end

    boolean = is_word_guessed(secret_word, letters_guessed)
  end
end
=end


#hangman(secret_word)

letters_guessed = []
secret_word = choose_word(word_list).downcase
i = 8
final_message = ''


get '/' do

  secret = get_guessed_word(secret_word, letters_guessed)

  message = "#{secret}"

  letters = get_available_letters(letters_guessed)

  erb :index, :locals => {:letters => letters, :secret_word => secret_word, :message => message, :i => i, :final_message => final_message}
end

post '/' do

  restart = params['restart']

  if restart == "true"
    letters_guessed = []
    secret_word = choose_word(word_list).downcase
    i = 9
    final_message = ''
  end

  if letters_guessed.include?(params['letter'])
    message = "Oops! You've already guessed that letter"
  else
    letters_guessed.push(params['letter'])
  end

  secret = get_guessed_word(secret_word, letters_guessed)

  secret_word_copy = secret_word.split('')

  if secret_word_copy.include?(params['letter'])
    message = "Good guess: #{secret}"
  else
    i -= 1
    message = "Oops! That letter is not in the word: #{secret}"
  end

  letters = get_available_letters(letters_guessed)

  if i == 0
    final_message = "Sorry, you ran out of guesses\nThe word was #{secret_word}"
  end

  if is_word_guessed(secret_word, letters_guessed)
    final_message = "Correct, that is the word!"
  end

  redirect back
  erb :index, :locals => {:letters => letters, :secret_word => secret_word, :message => message, :i => i, :final_message => final_message}
end

