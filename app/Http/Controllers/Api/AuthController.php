<?php 
namespace App\Http\Controllers\Api; 

use App\Http\Controllers\Controller; 
use Illuminate\Http\Request; 
use App\Models\User; 
use Illuminate\Support\Facades\Hash; 

class AuthController extends Controller 
{ 
    // REGISTER 
    public function register(Request $request) 
    { 
        $request->validate([ 
            'name' => 'required', 
            'email' => 'required|email|unique:users', 
            'password' => 'required|min:6', 
        ]); 

        User::create([ 
            'name' => $request->name, 
            'email' => $request->email, 
            'password' => Hash::make($request->password), 
        ]);

        return response()->json([ 
            'message' => 'Register berhasil' 
        ]); 
    } 

    // LOGIN 
    public function login(Request $request) 
    { 
        $user = User::where('email', $request->email)->first(); 

        if (!$user || !Hash::check($request->password, $user->password)) { 
            return response()->json([ 
                'message' => 'Email atau password salah' 
            ], 401); 
        } 

        $token = $user->createToken('auth_token')->plainTextToken; 

        return response()->json([ 
            'token' => $token, 
            'user' => $user 
        ]); 
    } 

    // GET USER 
    public function me(Request $request) 
    { 
        return response()->json($request->user()); 
    } 
}
